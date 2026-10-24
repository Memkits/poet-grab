import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {mkdirSync,readFileSync,writeFileSync} from 'node:fs';
const run=(...args)=>execFileSync(process.env.POET_QUERY_CLI||'calcit',args,{encoding:'utf8',maxBuffer:10e6,stdio:['ignore','pipe','pipe']});
function normalizeSets(value){
  if(Array.isArray(value))return value.map(normalizeSets);
  if(value&&typeof value==='object'){
    const result=Object.fromEntries(Object.entries(value).map(([k,v])=>[k,normalizeSets(v)]));
    if(Object.keys(result).length===1&&Array.isArray(result.__edn_set))result.__edn_set.sort((a,b)=>JSON.stringify(a).localeCompare(JSON.stringify(b)));
    return result;
  }
  return value;
}
const q=(...args)=>normalizeSets(JSON.parse(run('query',...args,'--format','json')).data);
mkdirSync('acceptance',{recursive:true});
function inventory(){
  const defs=[];
  for(const ns of q('ns').namespaces){
    const names=run('query','defs',ns).split('\n').filter(x=>/^  \S/.test(x)).map(x=>x.trim().split(' ')[0]);
    assert.equal(names.length,q('ns',ns).definition_count);
    for(const name of names)defs.push(q('def',ns+'/'+name));
  }
  return defs;
}
const aliases={merge:'.merge','option:unwrap-or':'.unwrap-or'};
function select(defs,check){
  const ops=[],counts={};
  function walk(node,path,id){
    if(!Array.isArray(node))return;
    if(['quote','quasiquote',';','comment','defmacro'].includes(node[0]))return;
    if(Object.hasOwn(aliases,node[0])){
      const old=node[0];
      if(old==='merge'){assert.equal(id,'app.comp.container/comp-container');assert.ok([3,4].includes(node.length));}
      else {assert.equal(id,'app.config/dev?');assert.equal(node.length,3);}
      const p='@'+[...path,0].join('.');
      if(check)assert.equal(JSON.parse(run('tree','show',id,'--path',p,'--format','json')).tree,old);
      ops.push(['tree','replace',id,'--path',p,'--input-format','json-ast','--code',JSON.stringify(aliases[old]),'--expect','quote '+old]);
      counts[old]=(counts[old]||0)+1;node[0]=aliases[old];
    }
    node.forEach((child,i)=>walk(child,[...path,i],id));
  }
  defs.forEach(def=>walk(def.code,[],def.id));return {ops,counts};
}
if(process.argv[2]==='inventory'){
  const defs=inventory();writeFileSync('acceptance/reviewed.json',JSON.stringify(defs,null,2));
  console.log(JSON.stringify({definitions:defs.length,tests:defs.reduce((n,d)=>n+d.tests.length,0),counts:select(structuredClone(defs),false).counts}));process.exit(0);
}
if(process.argv[2]==='verify'){
  const actual=inventory();assert.deepEqual(actual,normalizeSets(JSON.parse(readFileSync(process.argv[3],'utf8'))));
  console.log(JSON.stringify({verifiedDefinitions:actual.length,tests:actual.reduce((n,d)=>n+d.tests.length,0)}));process.exit(0);
}
assert.equal(run('-v').trim(),'0.30.1');run('docs','agents','--contract');
const before=inventory(),config=q('config'),namespaces=q('ns').namespaces.map(ns=>q('ns',ns));
assert.deepEqual(before,normalizeSets(JSON.parse(readFileSync('acceptance/reviewed.json','utf8'))));
const expected=structuredClone(before),{ops,counts}=select(expected,true);
assert.deepEqual(counts,{merge:2,'option:unwrap-or':1});assert.equal(ops.length,3);
writeFileSync('acceptance/before.json',JSON.stringify(before,null,2));
writeFileSync('acceptance/operations.json',JSON.stringify(ops,null,2));writeFileSync('acceptance/counts.json',JSON.stringify(counts,null,2));
const args=['edit','transaction','--file','acceptance/operations.json','--format','json'];
const preview=JSON.parse(run(...args,'--dry-run'));assert.ok(preview.scoped_revision);
writeFileSync('acceptance/preview.json',JSON.stringify(preview,null,2));writeFileSync('acceptance/applied.json',run(...args,'--expect-revision',preview.scoped_revision));
assert.deepEqual(inventory(),expected);assert.deepEqual(q('config'),config);
assert.deepEqual(q('ns').namespaces.map(ns=>q('ns',ns)),namespaces);
writeFileSync('acceptance/after.json',JSON.stringify(expected,null,2));
writeFileSync('acceptance/snapshot-blob.txt',execFileSync('git',['hash-object','calcit.cirru'],{encoding:'utf8'}));
console.log(JSON.stringify({guardedDefinitions:before.length,operations:ops.length,counts,unchanged:'arguments/defaults/schemas/FFI/metadata/imports/config and all attached tests/examples'}));
