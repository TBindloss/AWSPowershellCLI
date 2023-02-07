$Regions = "eu-west-2","eu-west-1"
$Account = aws sts get-caller-identity --query 'Account' | ?{$_ -ne""}
$Account = $Account.Replace("`"","")
Echo "Account ID: $Account"

foreach ($Region in $Regions){
    echo $Region
    #Get all 'Stopped' instances
    $Instances = aws ec2 describe-instances --region $Region --filters "Name=instance-state-code,Values=80" --query 'Reservations[].Instances[].InstanceId'
    $IN = $Instances -Replace'[,]','' -Replace '[][]','' -replace '["]',''
    $IN = $IN.Trim()
    $IN = $IN | ?{$_ -ne""} 
    #Loop through each instance to find shutdown time
        foreach ($Instance in $IN){
            $Name = aws ec2 describe-tags --region $Region --filters "Name=resource-id,Values=$Instance" "Name=key,Values=Name" --output text | cut -f5 
            $Time = aws ec2 describe-instances --region $Region --instance-ids $Instance --query 'Reservations[].Instances[].StateTransitionReason'
            $Time = $Time.Replace("`"","") 
            $Time = $Time.Trim()
            $Time = $Time -Replace'[,]','' -Replace '[][]',''
            $Time = $Time | ?{$_ -ne""}  
            Echo "- Server - $Name : Shutdown Report : $Time"
        }
    }
