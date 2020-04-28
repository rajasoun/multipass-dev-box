#### Update application specific information:

1 ) Application code should clone under below location:
```
${HOME}/workspace/bizapps/htd
```
2 ) Run below command for update configs (make sure you cd'ed to config folder) 

```
scripts/update_config.sh {salesinsights|leads|rmt}|{clean} <AWS profile name>
```  
 3 ) Application deployment scripts located under  app_scripts.
 
 4 ) Applications deployment logs located under logs/.
 
Rest of the steps you follow the ReadMe.md at root folder.
