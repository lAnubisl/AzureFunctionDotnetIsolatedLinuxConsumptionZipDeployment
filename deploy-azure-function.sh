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

#Note: Unnecessary use of -X or --request, POST is already inferred.
#*   Trying 20.50.2.60:443...
#* Connected to func-dotnet-deployment-test.scm.azurewebsites.net (20.50.2.60) port 443 (#0)
#* ALPN, offering h2
#* ALPN, offering http/1.1
#* successfully set certificate verify locations:
#*  CAfile: /etc/ssl/certs/ca-certificates.crt
#*  CApath: /etc/ssl/certs
#* TLSv1.3 (OUT), TLS handshake, Client hello (1):
#* TLSv1.3 (IN), TLS handshake, Server hello (2):
#* TLSv1.2 (IN), TLS handshake, Certificate (11):
#* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
#* TLSv1.2 (IN), TLS handshake, Server finished (14):
#* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
#* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
#* TLSv1.2 (OUT), TLS handshake, Finished (20):
#* TLSv1.2 (IN), TLS handshake, Finished (20):
#* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
#* ALPN, server accepted to use http/1.1
#* Server certificate:
#*  subject: C=US; ST=WA; L=Redmond; O=Microsoft Corporation; CN=*.azurewebsites.net
#*  start date: Mar 10 03:05:55 2023 GMT
#*  expire date: Mar  4 03:05:55 2024 GMT
#*  subjectAltName: host "func-dotnet-deployment-test.scm.azurewebsites.net" matched cert's "*.scm.azurewebsites.net"
#*  issuer: C=US; O=Microsoft Corporation; CN=Microsoft Azure TLS Issuing CA 02
#*  SSL certificate verify ok.
#* Server auth using Basic with user '$func-dotnet-deployment-test'
#> POST /api/zipdeploy HTTP/1.1
#> Host: func-dotnet-deployment-test.scm.azurewebsites.net
#> Authorization: Basic ###############################################################################
#> User-Agent: curl/7.74.0
#> Accept: */*
#> Content-Length: 6101240
#> Content-Type: application/x-www-form-urlencoded
#> Expect: 100-continue
#> 
#* Mark bundle as not supporting multiuse
#< HTTP/1.1 100 Continue
#* We are completely uploaded and fine
#* Mark bundle as not supporting multiuse
#< HTTP/1.1 200 OK
#< Content-Length: 0
#< Date: Thu, 18 May 2023 14:20:58 GMT
#< Server: Kestrel
#< Set-Cookie: ARRAffinity=#######################################################;Path=/;HttpOnly;Secure;Domain=func-dotnet-deployment-test.scm.azurewebsites.net
#< Set-Cookie: ARRAffinitySameSite=#######################################################;Path=/;HttpOnly;SameSite=None;Secure;Domain=func-dotnet-deployment-test.scm.azurewebsites.net
#< SCM-DEPLOYMENT-ID: 9783ee1f-cd1e-4cf0-ba38-4fd9acbcdd29


curl -X GET --user $CREDENTIALS https://$DEPLOYMENT_APP.scm.azurewebsites.net:443/deployments

[
   {
      "id":"9783ee1f-cd1e-4cf0-ba38-4fd9acbcdd29",
      "status":4,
      "status_text":"",
      "author_email":"N/A",
      "author":"N/A",
      "deployer":"Push-Deployer",
      "message":"Created via a push deployment",
      "progress":"",
      "received_time":"2023-05-18T14:20:52.3124148Z",
      "start_time":"2023-05-18T14:20:53.3522587Z",
      "end_time":"2023-05-18T14:20:58.6861924Z",
      "last_success_end_time":"2023-05-18T14:20:58.6861924Z",
      "complete":true,
      "active":true,
      "is_temp":false,
      "is_readonly":true,
      "url":"https://func-dotnet-deployment-test.scm.azurewebsites.net/deployments/9783ee1f-cd1e-4cf0-ba38-4fd9acbcdd29",
      "log_url":"https://func-dotnet-deployment-test.scm.azurewebsites.net/deployments/9783ee1f-cd1e-4cf0-ba38-4fd9acbcdd29/log",
      "site_name":"func-dotnet-deployment-test"
   }
]

curl -X GET --user $CREDENTIALS https://func-dotnet-deployment-test.scm.azurewebsites.net/deployments/9783ee1f-cd1e-4cf0-ba38-4fd9acbcdd29/log
[
   {
      "log_time":"2023-05-18T14:20:52.3275863Z",
      "id":"a86ede7e-2555-4baa-8821-374e8ab13c7e",
      "message":"Updating submodules.",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:53.3432698Z",
      "id":"69a22108-806a-4012-b710-0d33973d36ec",
      "message":"Preparing deployment for commit id '9783ee1f-c'.",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:53.3808661Z",
      "id":"c7d9a145-f75a-462f-a944-516e409d4507",
      "message":"PreDeployment: context.CleanOutputPath False",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:53.3938978Z",
      "id":"d4a8ac86-2c2e-4c5e-826d-2f1ebe32afaa",
      "message":"PreDeployment: context.OutputPath /home/site/wwwroot",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:53.4070023Z",
      "id":"01b10f63-cb87-458f-bb6c-ac891d437df5",
      "message":"Generating deployment script.",
      "type":0,
      "details_url":"https://func-dotnet-deployment-test.scm.azurewebsites.net/deployments/9783ee1f-cd1e-4cf0-ba38-4fd9acbcdd29/log/01b10f63-cb87-458f-bb6c-ac891d437df5"
   },
   {
      "log_time":"2023-05-18T14:20:53.7699246Z",
      "id":"d1845125-d613-4891-8533-52a46659937e",
      "message":"Running deployment command...",
      "type":0,
      "details_url":"https://func-dotnet-deployment-test.scm.azurewebsites.net/deployments/9783ee1f-cd1e-4cf0-ba38-4fd9acbcdd29/log/d1845125-d613-4891-8533-52a46659937e"
   },
   {
      "log_time":"2023-05-18T14:20:54.1662601Z",
      "id":"4f1f9ab9-6107-49ea-8387-721ff8ea15df",
      "message":"Running post deployment command(s)...",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:54.1900088Z",
      "id":"5a7b1c67-7e64-496d-9cf7-27d0bc51e3ca",
      "message":"Triggering recycle (preview mode disabled).",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:54.21202Z",
      "id":"ce044965-0686-432e-9877-b7e1a5cbe29a",
      "message":"Linux Consumption plan has a 1.5 GB memory limit on a remote build container.",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:54.2250486Z",
      "id":"489c7a2e-9315-4891-b07b-9611c892b51e",
      "message":"To check our service limit, please visit https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale#service-limits",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:54.2372183Z",
      "id":"ea73318f-9500-4055-830c-86f32fa3e055",
      "message":"Writing the artifacts to a squashfs file",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.3438724Z",
      "id":"db34024e-c950-4342-a73b-120f7f404dc3",
      "message":"Parallel mksquashfs: Using 1 processor",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.3642189Z",
      "id":"024d5b2d-f81a-4984-a76f-36940acbcdef",
      "message":"Creating 4.0 filesystem on /home/site/artifacts/functionappartifact.squashfs, block size 131072.",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.383456Z",
      "id":"3ed4707d-e0c7-4c83-b8bd-ab6d5b269547",
      "message":"",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.3973401Z",
      "id":"9997d9c4-3ebd-4d05-bc32-9e8566b9dbdc",
      "message":"[===============================================================|] 187/187 100%",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.4141325Z",
      "id":"c930c393-bd52-4f9a-beca-6b520860effe",
      "message":"",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.4291071Z",
      "id":"e0ab69a2-ddf9-47b1-9413-a99803e6f483",
      "message":"Exportable Squashfs 4.0 filesystem, gzip compressed, data block size 131072",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.4415339Z",
      "id":"fa7495b4-ca88-4c6c-b606-932439a13de1",
      "message":"\tcompressed data, compressed metadata, compressed fragments, compressed xattrs",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.4620447Z",
      "id":"92813895-c1d9-45e8-acbb-2768f34dc234",
      "message":"\tduplicates are removed",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.4763664Z",
      "id":"37c76175-7104-43c8-8e50-cf7d33210308",
      "message":"Filesystem size 5872.98 Kbytes (5.74 Mbytes)",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.4861777Z",
      "id":"4725f912-7e64-4d2d-bcf4-e3ee45150064",
      "message":"\t34.61% of uncompressed filesystem size (16971.07 Kbytes)",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.5032473Z",
      "id":"77a5ae92-8eae-47ce-a91a-4d280091c956",
      "message":"Inode table size 1512 bytes (1.48 Kbytes)",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.5174181Z",
      "id":"76b4de8f-36b7-4f19-a156-2992be0ce976",
      "message":"\t39.85% of uncompressed inode table size (3794 bytes)",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.53451Z",
      "id":"70247596-f314-4660-9872-ddf12dd48463",
      "message":"Directory table size 1220 bytes (1.19 Kbytes)",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.549235Z",
      "id":"229f9afa-81d4-4c07-a275-de816704cc18",
      "message":"\t29.09% of uncompressed directory table size (4194 bytes)",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.5694961Z",
      "id":"8ad1940a-9f98-4bfc-b844-259300c4424f",
      "message":"Number of duplicate files found 0",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.5843444Z",
      "id":"a738725d-2043-4c9e-b1d1-6866a9769076",
      "message":"Number of inodes 103",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.5969335Z",
      "id":"9606b896-120a-43d2-8431-eb08595a240e",
      "message":"Number of files 84",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.6097717Z",
      "id":"ba19af1d-9b7c-462d-86e1-c1a7fa3bfe36",
      "message":"Number of fragments 22",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.6284079Z",
      "id":"09db5871-34f6-421c-ad4f-4c8ce1c94dc5",
      "message":"Number of symbolic links  0",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.6416211Z",
      "id":"49d7e190-44bd-402a-88fc-ddec5bd9da95",
      "message":"Number of device nodes 0",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.6620625Z",
      "id":"8281da48-c370-4961-8807-7ca883052f48",
      "message":"Number of fifo nodes 0",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.6750233Z",
      "id":"9591c8db-7dd1-41f6-a7a8-9841ca210ae2",
      "message":"Number of socket nodes 0",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.688495Z",
      "id":"513c0869-5d9c-4eb6-9374-87e3e4d26cf8",
      "message":"Number of directories 19",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.7015127Z",
      "id":"0b521475-f9fd-4354-a6ce-6edc33d1e1b2",
      "message":"Number of ids (unique uids + gids) 1",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.7149582Z",
      "id":"eedb7a99-5951-40d8-ae0c-8731eded8e3a",
      "message":"Number of uids 1",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.7288515Z",
      "id":"8213978e-4085-4135-a869-03c647dfcb4b",
      "message":"\troot (0)",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.7415041Z",
      "id":"169dff79-e45f-4409-a610-795485e1a71f",
      "message":"Number of gids 1",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.7628124Z",
      "id":"de1366ce-087b-41dd-a0e0-5cd803a324d3",
      "message":"\troot (0)",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.7759652Z",
      "id":"66fb039a-60ac-4848-8d7e-781fdc5a8248",
      "message":"Creating placeholder blob for linux consumption function app...",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.7967268Z",
      "id":"42e5e1e5-f766-44c5-99e6-438a683757ec",
      "message":"SCM_RUN_FROM_PACKAGE placeholder blob scm-latest-func-dotnet-deployment-test.zip located",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:57.8123624Z",
      "id":"c03a64cb-c67e-43b0-8488-2def85dcc8b3",
      "message":"Uploading built content /home/site/artifacts/functionappartifact.squashfs for linux consumption function app...",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:58.3930546Z",
      "id":"fbcbfd54-c40c-4959-a9cb-a673770ff8ab",
      "message":"Resetting all workers for func-dotnet-deployment-test.azurewebsites.net",
      "type":0,
      "details_url":null
   },
   {
      "log_time":"2023-05-18T14:20:58.4758622Z",
      "id":"9dfe9e98-fcf2-4b63-b0d1-07971785465e",
      "message":"Deployment successful. deployer = Push-Deployer deploymentPath = Functions App ZipDeploy. Extract zip.",
      "type":0,
      "details_url":null
   }
]