module VerifyExamples.Accessors.SelectList.EachIdx2 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Test
import Expect

import Accessors.SelectList exposing (..)
import SelectList exposing (SelectList)
import Lens as L
import Accessors.SelectList as SL
import Accessors exposing (..)



multiplyIfGTOne : (Int, { bar : Int }) -> (Int, { bar : Int })
multiplyIfGTOne ( idx, ({ bar } as rec) ) =
    if idx > 0 then
        ( idx, { bar = bar * 10 } )
    else
        (idx, rec)
listRecord : { foo : SelectList { bar : Int } }
listRecord =
    { foo = SelectList.fromLists [{ bar = 1 }] { bar = 2 } [{ bar = 3 }, { bar = 4 }]
    }



spec2 : Test.Test
spec2 =
    Test.test "#eachIdx: \n\n    over (L.foo << SL.eachIdx) multiplyIfGTOne listRecord\n    --> { foo = SelectList.fromLists [{ bar = 1 }] { bar = 20 } [{ bar = 30 }, { bar = 40 }] }" <|
        \() ->
            Expect.equal
                (
                over (L.foo << SL.eachIdx) multiplyIfGTOne listRecord
                )
                (
                { foo = SelectList.fromLists [{ bar = 1 }] { bar = 20 } [{ bar = 30 }, { bar = 40 }] }
                )