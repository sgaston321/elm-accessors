module Dict.Accessors exposing (each, each_, at, id, at_)

{-| Dict.Accessors

@docs each, each_, at, id, at_

-}

import Base exposing (Relation)
import Dict exposing (Dict)
import Maybe.Accessors as Maybe


{-| values: This accessor lets you traverse a Dict including the index of each element

    import Accessors exposing (..)
    import Lens as L
    import Dict exposing (Dict)

    dictRecord : {foo : Dict String {bar : Int}}
    dictRecord = { foo = [ ("a", { bar = 2 })
                         , ("b", { bar = 3 })
                         , ("c", { bar = 4 })
                         ] |> Dict.fromList
                 }

    get (L.foo << values) dictRecord
    --> [("a", {bar = 2}), ("b", {bar = 3}), ("c", {bar = 4})] |> Dict.fromList

    over (L.foo << values << L.bar) ((*) 10) dictRecord
    --> {foo = [("a", {bar = 20}), ("b", {bar = 30}), ("c", {bar = 40})] |> Dict.fromList}

    get (L.foo << values << L.bar) dictRecord
    --> [("a", 2), ("b", 3), ("c", 4)] |> Dict.fromList

    over (L.foo << values << L.bar) ((+) 1) dictRecord
    --> {foo = [("a", {bar = 3}), ("b", {bar = 4}), ("c", {bar = 5})] |> Dict.fromList}

-}
each : Relation attribute reachable built -> Relation (Dict comparable attribute) reachable (Dict comparable built)
each =
    Base.makeOneToN "{_}"
        (\fn -> Dict.map (\_ -> fn))
        (\fn -> Dict.map (\_ -> fn))


{-| keyed: This accessor lets you traverse a Dict including the index of each element

    import Accessors exposing (..)
    import Lens as L
    import Dict exposing (Dict)

    dictRecord : {foo : Dict String {bar : Int}}
    dictRecord = { foo = [ ("a", { bar = 2 })
                         , ("b", { bar = 3 })
                         , ("c", { bar = 4 })
                         ] |> Dict.fromList
                 }

    multiplyIfA : (String, { bar : Int }) -> (String, { bar : Int })
    multiplyIfA ( key, ({ bar } as rec) ) =
        if key == "a" then
            ( key, { bar = bar * 10 } )
        else
            (key, rec)


    get (L.foo << keyed) dictRecord
    --> [("a", ("a", {bar = 2})), ("b", ("b", {bar = 3})), ("c", ("c", {bar = 4}))] |> Dict.fromList

    over (L.foo << keyed) multiplyIfA dictRecord
    --> {foo = [("a", {bar = 20}), ("b", {bar = 3}), ("c", {bar = 4})] |> Dict.fromList}

    get (L.foo << keyed << snd << L.bar) dictRecord
    --> [("a", 2), ("b", 3), ("c", 4)] |> Dict.fromList

    over (L.foo << keyed << snd << L.bar) ((+) 1) dictRecord
    --> {foo = [("a", {bar = 3}), ("b", {bar = 4}), ("c", {bar = 5})] |> Dict.fromList}

-}
each_ : Relation ( comparable, attribute ) reachable built -> Relation (Dict comparable attribute) reachable (Dict comparable built)
each_ =
    Base.makeOneToN "{_}"
        (\fn -> Dict.map (\idx -> Tuple.pair idx >> fn))
        (\fn -> Dict.map (\idx -> Tuple.pair idx >> fn >> Tuple.second))


{-| at: NON-structure preserving accessor over Dict's

In terms of accessors, think of Dicts as records where each field is a Maybe.

    import Dict exposing (Dict)
    import Accessors exposing (..)
    import Lens as L

    dict : Dict String {bar : Int}
    dict = Dict.fromList [("foo", {bar = 2})]

    get (at "foo") dict
    --> Just {bar = 2}

    get (at "baz") dict
    --> Nothing

    get (at "foo" << try << L.bar) dict
    --> Just 2

    set (at "foo") Nothing dict
    --> Dict.remove "foo" dict

    set (at "baz" << try << L.bar) 3 dict
    --> dict

-}
at : String -> Relation (Maybe attribute) reachable wrap -> Relation (Dict String attribute) reachable wrap
at =
    at_ identity


{-| id: NON-structure preserving accessor over Dict's

In terms of accessors, think of Dicts as records where each field is a Maybe.

    import Dict exposing (Dict)
    import Accessors exposing (..)
    import Lens as L

    dict : Dict Int {bar : Int}
    dict = Dict.fromList [(1, {bar = 2})]

    get (id 1) dict
    --> Just {bar = 2}

    get (id 0) dict
    --> Nothing

    get (id 1 << try << L.bar) dict
    --> Just 2

    set (id 1) Nothing dict
    --> Dict.remove 1 dict

    set (id 0 << try << L.bar) 3 dict
    --> dict

-}
id : Int -> Relation (Maybe attribute) reachable wrap -> Relation (Dict Int attribute) reachable wrap
id =
    at_ String.fromInt


{-| `at_`: NON-structure preserving accessor over Dict's

In terms of accessors, think of Dicts as records where each field is a Maybe.

    import Dict exposing (Dict)
    import Accessors exposing (..)
    import Lens as L

    dict : Dict Char {bar : Int}
    dict = Dict.fromList [('C', {bar = 2})]

    atC : Char -> Relation (Maybe attribute) reachable wrap -> Relation (Dict Char attribute) reachable wrap
    atC =
        at_ String.fromChar

    get (atC 'C') dict
    --> Just {bar = 2}

    get (atC 'Z') dict
    --> Nothing

    get (atC 'C' << try << L.bar) dict
    --> Just 2

    set (atC 'C') Nothing dict
    --> Dict.remove 'C' dict

    set (atC 'Z' << try << L.bar) 3 dict
    --> dict

-}
at_ : (comparable -> String) -> comparable -> Relation (Maybe attribute) reachable wrap -> Relation (Dict comparable attribute) reachable wrap
at_ toS k =
    Base.makeOneToOne ("{" ++ toS k ++ "}") (Dict.get k) (Dict.update k)