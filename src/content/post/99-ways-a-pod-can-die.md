As the architect and operator of machine learning pipelines, I've investigated countless mysterious missing pods.

Here are a few of the causes.

### OOMKill

### Scale-down

### AZ rebalancing



### TooManyActivePods: Too many active pods running after completion count reached

WARN Via Kubernetes
Events from the Job stg/lb-rdx5-rc43-ab780-1654768723
22h ago
1 TooManyActivePods: Too many active pods running after completion count reached
Events emitted by the job-controller seen at 2022-06-09 10:31:24 +0000 UTC since 2022-06-09 10:31:24 +0000 UTC


WARN Via Kubernetes
Events from the Job stg/lb-rdx5-rc43-2aa9e-1654768719
22h ago
1 TooManyActivePods: Too many active pods running after completion count reached
Events emitted by the job-controller seen at 2022-06-09 10:31:24 +0000 UTC since 2022-06-09 10:31:24 +0000 UTC


WARN Via Kubernetes
Events from the Pod stg/lb-rdx5-rc43-ac4d9-1654769319-kpctv
22h ago
4 Failed: Error: context deadline exceeded
Events emitted by the kubelet seen at 2022-06-09 10:27:26 +0000 UTC since 2022-06-09 10:15:14 +0000 UTC

### Adding new tags to node group

```
# NOTE: we don't run `aws autoscaling start-instance-refresh` here because it causes unwanted termination of the node's pods:
# && aws autoscaling start-instance-refresh --auto-scaling-group-name ${local.asg_name} --preferences SkipMatching=true
#
# Notes re: "start-instance-refresh":
# "When you add a tag to your Auto Scaling group, you can specify whether it should be added to instances launched in the Auto Scaling group.
# If you modify a tag, the updated version of the tag is added to instances launched in the Auto Scaling group after the change.
# If you create or modify a tag for an Auto Scaling group, these changes are not made to instances that are already running in the Auto Scaling group."
# https://docs.aws.amazon.com/autoscaling/ec2/userguide/autoscaling-tagging.html#add-tags
#
# To disable AZ rebalancing, append to above command:
# aws autoscaling suspend-processes --scaling-processes AZRebalance --auto-scaling-group-name ${local.asg_name}
```





Unrelated, but autoscaling gotchas: PREFER_NO_SCHEDULE
