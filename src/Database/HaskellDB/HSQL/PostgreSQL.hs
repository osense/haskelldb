-----------------------------------------------------------
-- |
-- Module      :  HaskellDB
-- Copyright   :  Daan Leijen (c) 1999, daan@cs.uu.nl
--                HWT Group (c) 2003, dp03-7@mdstud.chalmers.se
-- License     :  BSD-style
-- 
-- Maintainer  :  dp03-7@mdstud.chalmers.se
-- Stability   :  experimental
-- Portability :  portable
--
--
-- $Revision: 1.9 $
-----------------------------------------------------------
module Database.HaskellDB.HSQL.PostgreSQL (
		      PostgreSQLOptions(..),
		      postgresqlConnect,
		      driver
		      ) where

import Database.HaskellDB.Database
import Database.HaskellDB.HSQL.Common
import Database.HaskellDB.DriverAPI
import qualified Database.HSQL.PostgreSQL as PostgreSQL (connect) 

data PostgreSQLOptions = PostgreSQLOptions { 
				  server :: String, -- ^ server name
				  db :: String,     -- ^ database name
				  uid :: String,    -- ^ user id
				  pwd :: String     -- ^ password
                  		 }

postgresqlConnect :: PostgreSQLOptions -> (Database -> IO a) -> IO a
postgresqlConnect = 
    hsqlConnect (\opts -> PostgreSQL.connect 
		            (server opts) (db opts) (uid opts) (pwd opts))

postgresqlConnectOpts :: [(String,String)] -> (Database -> IO a) -> IO a
postgresqlConnectOpts opts f = 
    do
    [a,b,c,d] <- getOptions ["server","db","uid","pwd"] opts
    postgresqlConnect (PostgreSQLOptions {server = a,
                                          db = b,
                                          uid = c,
			                  pwd = d}) f

driver = defaultdriver {connect = postgresqlConnectOpts}
