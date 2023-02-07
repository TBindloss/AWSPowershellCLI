#Get all buckets
$Buckets = aws s3api list-buckets --query 'Buckets[].Name'
$Buckets = $Buckets -Replace'[,]','' -Replace '[][]','' -replace '["]',''
$Buckets = $Buckets.Trim()
$Buckets = $Buckets | ?{$_ -ne""} 

#Set bucket tags
foreach ($Bucket in $Buckets){
aws s3api put-bucket-versioning --bucket $Bucket --versioning-configuration Status=Enabled
}
