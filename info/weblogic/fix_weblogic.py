# Load the WebLogic domain template
readTemplate('C:/Oracle/Middleware/wlserver/common/templates/wls/wls.jar')

# Configure the Admin Server
cd('Servers/AdminServer')
set('ListenAddress', 'localhost')
set('ListenPort', 7001)

# Configure the admin user and password
cd('/')
cd('Security/base_domain/User/weblogic')
cmo.setPassword('password123')

# Set options and create the domain
setOption('OverwriteDomain', 'true')
writeDomain('C:/Oracle/Middleware/user_projects/domains/base_domain')
closeTemplate()
exit()