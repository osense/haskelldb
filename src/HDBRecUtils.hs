-----------------------------------------------------------
-- |
-- Module      :  HDBRecUtils
-- Copyright   :  HWT Group (c) 2003, dp03-7@mdstud.chalmers.se
-- License     :  BSD-style
-- 
-- Maintainer  :  dp03-7@mdstud.chalmers.se
-- Stability   :  experimental
-- Portability :  portable
-- 
-- This module contains utility functions for HDBRec.
-----------------------------------------------------------
module Database.HaskellDB.HDBRecUtils (hdbMakeEntry, 
		    mkAttr,
		    ( << ),
		    ( # ),
		    SelectField(..)
		   ) where

import Database.HaskellDB.HDBRec
import Database.HaskellDB.Query

-- * Functions

-- | Constructs a table entry from a field tag
hdbMakeEntry :: FieldTag f => 
		f -- ^ Field tag
	     -> b -- ^ Rest of the record
	     -> HDBRecCons f (Expr a) b
hdbMakeEntry f = HDBRecCons (attribute (fieldName f))

-- | Make an 'Attr' for a field.
mkAttr :: FieldTag f => 
	  f -- ^ Field tag
       -> Attr f a
mkAttr = Attr . fieldName

-- * Operators

infix  6 <<
infixr 5 #

-- | Links together a type and a value into an entry.
( << ) :: Attr f a 
       -> Expr a
       -> (b -> HDBRecCons f (Expr a) b)
_ << x = HDBRecCons x

-- | Links two fields together.
( # ) :: (b -> c) -> (a -> b) -> a -> c
f1 # f2 = f1 . f2


class SelectField f r a where
    -- | Gets the value of a field from a record.
    selectField :: Attr f a -> r -> a

instance SelectField f (HDBRecCons f a r) a where
    selectField _ (HDBRecCons x _) = x

instance SelectField f r a => SelectField f (HDBRecCons g b r) a where
    selectField f (HDBRecCons _ r) = selectField f r

instance SelectField f r a => SelectField f (HDBRec r) a where
    selectField f r = selectField f (r HDBRecTail)