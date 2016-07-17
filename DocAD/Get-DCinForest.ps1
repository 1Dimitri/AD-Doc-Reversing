try {
$RootDSE=([ADSI]"LDAP://RootDSE")
$ForestRootDomain=$RootDSE.rootDomainNamingContext        
$ldapQuery = "(&(objectClass=nTDSDSA))"
              $ObjAD = new-object System.DirectoryServices.DirectoryEntry
              $ADSearcher = new-object system.directoryservices.directorysearcher –argumentlist $ObjAD,$ldapQuery
              $Root = New-Object DirectoryServices.DirectoryEntry "LDAP://CN=Sites,CN=Configuration,$ForestRootDomain"
              $ADSearcher.SearchRoot = $Root
              try 
              {
                    $QueryResult = $ADSearcher.findall()
                    $QueryResult | 
                    foreach {
                          $ldapDN=$_.Path.replace("LDAP://CN=NTDS Settings,","")
                          $ldapDN
        
                    }
              }
              catch 
              {
                  write-host "Exception raised by SearchDirectory:"
                  write-host $_ -fore red
                  break
              }
}
   catch 
              {
                  write-host "Exception raised by RootDSE retrieval:"
                  write-host $_ -fore red
                  break
              }