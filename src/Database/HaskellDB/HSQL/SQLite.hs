-----------------------------------------------------------
-- |
-- Module      :  HaskellDB
-- Copyright   :  Daan Leijen (c) 1999, daan@cs.uu.nl
--                HWT Group (c) 2003, dp03-7@mdstud.chalmers.se
-- License     :  BSD-style
-- 
-- Maintainer  :  dp03-7@mdstud.chalmers.se
-- Stability   :  experimental
-- Portability :  non-portable
--
-- Interface to the SQLite <http://www.hwaci.com/sw/sqlite/>
-- databases.
--
-- $Revision: 1.5 $
-----------------------------------------------------------
module Database.HaskellDB.HSQL.SQLite (
		   SQLiteOptions(..),
		   sqliteConnect,
		   driver
		  ) where

import Database.HaskellDB.Database
import Database.HaskellDB.HSQL.Common
import Database.HaskellDB.DriverAPI
import qualified Database.HSQL.SQLite as SQLite (connect) 
import System.IO

data SQLiteOptions = SQLiteOptions { 
				    filepath :: FilePath, -- ^ database file
				    mode :: IOMode        -- ^ access mode
                  		   }

sqliteConnect :: SQLiteOptions -> (Database -> IO a) -> IO a
sqliteConnect = 
    hsqlConnect (\opts -> SQLite.connect 
		            (filepath opts) (mode opts))

sqliteConnectOpts :: [(String,String)] -> (Database -> IO a) -> IO a
sqliteConnectOpts opts f = 
    do
    [a,b] <- getOptions ["filepath","mode"] opts
    m <- readIOMode b
    sqliteConnect (SQLiteOptions {filepath = a,
				  mode = m}) f

readIOMode :: Monad m => String -> m IOMode
readIOMode s = 
    case s of
           "r" -> return ReadMode
           "w" -> return WriteMode
           "a" -> return AppendMode
           "rw" -> return ReadWriteMode
           _ -> case reads s of
                             [(x,"")] -> return x
                             _ -> fail $ "Bad IO mode: " ++ s

driver = defaultdriver {connect = sqliteConnectOpts}
