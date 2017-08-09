
#!/usr/bin/env bash

# exit on error
set -eu

if [ ! -f /usr/local/bin/ecs-cli ]; then
  ECSCLI_SRC=https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest
  curl -o /usr/local/bin/ecs-cli $ECSCLI_SRC
  chmod 755 /usr/local/bin/ecs-cli
fi

ecs-cli configure \
  --cluster $AWS_ECS_CLUSTER \
  --compose-project-name-prefix "ecs-${APP_NAME}-" \
  --compose-service-name-prefix "ecs-${APP_NAME}-svc-" \
  --cfn-stack-name-prefix "ecs-${APP_NAME}-setup-"

ecs-cli up --capability-iam --verbose \
  --keypair $AWS_EC2_KEYPAIR \
  --size $AWS_ECS_SIZE \
  --instance-type $AWS_EC2_INSTANCE_TYPE \
  --vpc $AWS_EC2_VPC \
  --subnets $AWS_EC2_SUBNETS \
  --force

  # --security-group $AWS_EC2_SECURITY_GROUP \

# REMOVED: Error executing 'up': You can only specify '--vpc' or '--azs'
# --azs $AWS_EC2_AZS \

for arg in "${@:2}"; do
  echo "$arg="$(eval echo \$$arg)
done > $ECS_ENVFILE

sh $1 > $ECS_DEPLOYMENT
