
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/ |js-ffi/
      :type-slots $ {} $ :dispatch-op |app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {} $ 'comp-container
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
                content $ :content store
              div
                {} $ :style $ .merge ui/global ui/row
                textarea $ {} (:value content) (:placeholder |Content)
                  :style $ .merge ui/flex ui/textarea $ {} (:height 320)
                  :on-input $ fn (e d!)
                    d! $ Op :content $ decode-map-as
                      .unwrap $ get e :value
                      , 'String
                =< |8px nil
                div
                  {} $ :style ui/flex
                  <> "|This is some content with code"
                  =< |8px nil
                  button $ {} (:style ui/button) (:inner-text |run)
                    :on-click $ fn (e d!) (println content)
                when dev? $ comp-typed-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'reel.typed/State 'app.schema/Op 'app.schema/Store
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            respo-ui.core :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> div button textarea span
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-typed-reel
            app.config :refer $ dev?
            app.schema :refer $ Op
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} (:dev-ui |http://localhost:8100/main.css) (:release-ui |http://cdn.tiye.me/favored-fonts/main.css) (:cdn-url |https://cos-sh.tiye.me/Memkits/poet-grab/) (:cdn-folder |tiye.me:cdn/calcit-workflow) (:title |Calcit) (:icon |http://cdn.tiye.me/logo/mvc-works.png) (:storage-key |workflow) (:upload-folder |tiye.me:repo/mvc-works/calcit-workflow/)
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel (typed/new-reel schema/store)
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'app.schema/Op 'app.schema/Store
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            if (enum? op)
              match (typed/decode-control op)
                (:some control)
                  reset! *reel $ typed/apply-control updater @*reel control
                (:none)
                  let
                      op-id $ generate-id!
                      op-time $ host/now-ms
                    reset! *reel $ typed/record-op updater @*reel (schema/decode-op op) op-id op-time
              raise |Expected-Enum-operation
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            match (js-ffi.browser/storage-get |workflow)
              (:some raw)
                try
                  dispatch! $ :: :hydrate-storage $ parse-cirru-edn raw
                  fn (message)
                    hud! |error $ str |Storage-migration-failed: message
                    raise message
              (:none) &unit
            render-app!
            add-watch! *reel :changes $ fn (r p) (render-app!)
            listen-devtools! |k dispatch!
            js-ffi.browser/add-event-listener! |beforeunload $ fn (_) (persist-storage!)
            repeat! 60 persist-storage!
            println "|App started."
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ dom/query-selector |.app
          :examples $ []
          :schema $ :: 'respo.dom/DomElement
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            let
                store $ :store @*reel
              js-ffi.browser/storage-set! |workflow $ format-cirru-edn $ {}
                :states $ :states store
                :content $ :content store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (clear-cache!)
            reset! *reel $ typed/refresh updater @*reel schema/store
            println "|Code updated."
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn repeat! (duration cb)
            js-ffi.browser/set-interval! cb $ * 1000 duration
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number $ :: 'Fn
              {} (:return 'Unit)
                :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render! clear-cache!
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
          :code $ quote $ defenum Op
            :states (:: 'List 'Dynamic) 'Dynamic
            :content 'String
            :hydrate-storage 'Store
            :unknown 'Enum
            :reel/toggle
            :reel/recall 'Number
            :reel/run
            :reel/step
            :reel/merge
            :reel/reset
            :reel/remove 'Number
          :examples $ []
          :schema $ :: 'EnumDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:content 'String)
            :states $ :: 'Map 'Dynamic 'Dynamic
          :examples $ []
          :schema $ :: 'StructDef
        'decode-op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-op (op)
            match op
              (:states cursor data)
                Op :states
                  decode-map-as cursor $ :: 'List 'Dynamic
                  , data
              (:content value)
                Op :content $ decode-map-as value 'String
              (:hydrate-storage data)
                Op :hydrate-storage $ decode-store data
              _ $ Op :unknown op
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Op)
            :args $ [] 'Enum
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (raw)
            decode-map-as
              if (struct? raw) (&struct:to-map raw) raw
              , Store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'Dynamic
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :content | :states $ {}
          :examples $ []
          :schema $ :: 'app.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor data)
                assoc store :states $ decode-map-as
                  assoc-in (:states store) (conj cursor :data) data
                  :: 'Map 'Dynamic 'Dynamic
              (:content value) (assoc store :content value)
              (:hydrate-storage data) data
              (:unknown original)
                do (println "|Unknown op:" original) store
              _ $ do (println "|Unknown op:" op) store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'app.schema/Op 'String 'Number
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
