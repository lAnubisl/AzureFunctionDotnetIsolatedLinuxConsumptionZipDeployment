# change current directory to 'Source'
cd Source

# build dotnet application
dotnet build Source.csproj --configuration Release --output publish

# create deployment artifact
cd publish
rm -rf local.settings.json
zip -r ../publish.zip .
cd ..

# deploy the artifact to the function app. You can find credentials on Azure Portal or use Terraform Outputs.
DEPLOYMENT_APP='func-dotnet-deployment-test'
DEPLOYMENT_USER='$func-dotnet-deployment-test'
DEPLOYMENT_PASSWORD='***********************'
CREDENTIALS=$DEPLOYMENT_USER:$DEPLOYMENT_PASSWORD
curl -v -X POST --user $CREDENTIALS --data-binary @"publish.zip" https://$DEPLOYMENT_APP.scm.azurewebsites.net:443/api/zipdeploy
#* TLSv1.2 (IN), TLS handshake, Certificate (11):
curl -X GET --user $CREDENTIALS https://$DEPLOYMENT_APP.scm.azurewebsites.net:443/deployments