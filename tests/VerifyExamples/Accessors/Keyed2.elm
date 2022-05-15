module VerifyExamples.Accessors.Keyed2 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Test
import Expect

import Accessors exposing (..)
import Dict exposing (Dict)
import Lens as L
import Accessors exposing (..)



multiplyIfA : (String, { bar : Int }) -> (String, { bar : Int })
multiplyIfA ( key, ({ bar } as rec) ) =
    if key == "a" then
        ( key, { bar = bar * 10 } )
    else
        (key, rec)
dictRecord : {foo : Dict String {bar : Int}}
dictRecord = { foo = [ ("a", { bar = 2 })
                     , ("b", { bar = 3 })
                     , ("c", { bar = 4 })
                     ] |> Dict.fromList
             }



spec2 : Test.Test
spec2 =
    Test.test "#keyed: \n\n    over (L.foo << keyed) multiplyIfA dictRecord\n    --> {foo = [(\"a\", {bar = 20}), (\"b\", {bar = 3}), (\"c\", {bar = 4})] |> Dict.fromList}" <|
        \() ->
            Expect.equal
                (
                over (L.foo << keyed) multiplyIfA dictRecord
                )
                (
                {foo = [("a", {bar = 20}), ("b", {bar = 3}), ("c", {bar = 4})] |> Dict.fromList}
                )