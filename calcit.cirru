
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/ |js-ffi/
      :type-slots $ {} $ :dispatch-op 'app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {} $ 'comp-container
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel on-control!)
            let
                store $ :store reel
                states $ :states store
                content $ :content store
              div
                {} $ :style $ .merge ui/global ui/row
                textarea $ {} (:value content) (:placeholder |Content)
                  :style $ .merge ui/flex ui/textarea $ {} (:height 320)
                  :on-input $ fn (e d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn Op $ -> Unit
                      -> Unit
                    d! $ Op :content $ decode-map-as (:value e) 'String
                space-x |8px
                div
                  {} $ :style ui/flex
                  <> "|This is some content with code"
                  space-x |8px
                  button $ {} (:style ui/button) (:inner-text |run)
                    :on-click $ fn (e d!) (println content)
                if dev?
                  Some $ comp-typed-reel (>> states :reel) reel ({}) on-control!
                  , None
          :examples $ []
          :schema $ quote $ Fn (reel.typed/State Op app.schema/Store)
            Fn reel.typed/Control $ -> Unit
            -> respo.schema/Component
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            respo-ui.core :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> div button textarea span
            respo.comp.space :refer $ space-x
            reel.comp.reel :refer $ comp-typed-reel
            app.config :refer $ dev?
            app.schema :refer $ Op
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ quote Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} (:dev-ui |http://localhost:8100/main.css) (:release-ui |http://cdn.tiye.me/favored-fonts/main.css) (:cdn-url |https://cos-sh.tiye.me/Memkits/poet-grab/) (:cdn-folder |tiye.me:cdn/calcit-workflow) (:title |Calcit) (:icon |http://cdn.tiye.me/logo/mvc-works.png) (:storage-key |workflow) (:upload-folder |tiye.me:repo/mvc-works/calcit-workflow/)
          :examples $ []
          :schema $ quote $ Map Tag String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel (typed/new-reel schema/store)
          :examples $ []
          :schema $ quote $ Ref (typed/State schema/Op schema/Store)
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            reset! *reel $ typed/record-op updater @*reel op (generate-id!) (host/now-ms)
            , &unit
          :examples $ []
          :schema $ quote $ Fn schema/Op (-> Unit) (:features :js-ffi)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            match (js-ffi.browser/storage-get |workflow)
              (:some raw)
                try
                  dispatch! $ schema/Op :hydrate-storage $ schema/decode-store (parse-cirru-edn raw)
                  fn (message)
                    hud! |error $ str |Storage-migration-failed: message
                    raise message
              (:none) &unit
            render-app!
            add-watch! *reel :changes $ fn (r p) (render-app!)
            listen-devtools! |k on-control!
            js-ffi.browser/add-event-listener! |beforeunload $ fn (_) (persist-storage!)
            repeat! 60 persist-storage!
            println "|App started."
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ dom/query-selector |.app
          :examples $ []
          :schema $ quote respo.dom/DomElement
        'on-control! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-control! (control)
            reset! *reel $ typed/apply-control updater @*reel control
            , &unit
          :examples $ []
          :schema $ quote $ Fn typed/Control (-> Unit)
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            let
                store $ :store @*reel
              js-ffi.browser/storage-set! |workflow $ format-cirru-edn $ {}
                :states $ :states store
                :content $ :content store
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (clear-cache!)
            reset! *reel $ typed/refresh updater @*reel schema/store
            println "|Code updated."
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*reel on-control!
              , dispatch!
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn repeat! (duration cb)
            js-ffi.browser/set-interval! cb $ * 1000 duration
            , &unit
          :examples $ []
          :schema $ quote $ Fn Number
            Fn $ -> Unit
            -> Unit
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.typed :as typed
            js-ffi.shared :as host
            respo.ffi.browser :as dom
            app.config :as config
            |bottom-tip :default hud!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op (:content String) (:hydrate-storage Store)
          :examples $ []
          :schema $ quote EnumDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:content String)
            :states $ Map respo.schema/CoordKey Dynamic
          :examples $ []
          :schema $ quote StructDef
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (raw)
            decode-map-as
              if (struct? raw) (&struct:to-map raw) raw
              , Store
          :examples $ []
          :schema $ quote $ Fn Input (-> Store) (:generics Input)
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :content | :states $ {}
          :examples $ []
          :schema $ quote Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:content value) (assoc store :content value)
              (:hydrate-storage data) data
          :examples $ []
          :schema $ quote $ Fn app.schema/Store app.schema/Op String Number (-> app.schema/Store)
          :tests $ []
            %{} 'TestEntry (:name |content-update)
              :code $ quote $ let
                  updated $ updater app.schema/store (app.schema/Op :content |hello) |test 0
                assert= |hello $ :content updated
                assert= (:states app.schema/store) (:states updated)
              :tags $ #{} :unit
            %{} 'TestEntry (:name |hydrate-storage)
              :code $ quote $ let
                  saved $ {}
                    :states $ {}
                    :content |saved
                  decoded $ app.schema/decode-store saved
                  updated $ updater app.schema/store (app.schema/Op :hydrate-storage decoded) |test 0
                assert= |saved $ :content updated
                assert= decoded $ app.schema/decode-store decoded
              :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
