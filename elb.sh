#!/bin/bash
LB_ARN=$(aws elbv2 create-load-balancer --name devops-alb --type application --subnets subnet-027476f8818e209e5 subnet-0f5edd2932a9d5809  --security-groups sg-0048235aeef4fcb10 | grep -oP '(?<="LoadBalancerArn": ")[^"]*' )


echo "$LB_ARN"
 
TG_ARN=$(aws elbv2 create-target-group --name devops-tg --protocol HTTP --port 8002 --vpc-id vpc-0be31b2a7996b5775 | grep -oP '(?<="TargetGroupArn": ")[^"]*')


echo "$TG_ARN"


aws elbv2 register-targets --target-group-arn $TG_ARN --targets Id=i-02301517b11d5d7c2f Id=i-05733685010b18a79


LS_ARN=$(aws elbv2 create-listener --load-balancer-arn $LB_ARN --protocol HTTP --port 8002  --default-actions Type=forward,TargetGroupArn=$TG_ARN | grep -oP '(?<="ListenerArn": ")[^"]*')


echo "$LS_ARN"


#aws elbv2 delete-load-balancer --load-balancer-arn $LB_ARN
#aws elbv2 delete-target-group --target-group-arn $TG_ARN
#aws elbv2 delete-listener --listener-arn LS_ARN
