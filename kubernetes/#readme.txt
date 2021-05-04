# Mini how-to guide
# -----------------

1) Create a PersistentVolume: pv-volume.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/work/docker/spoon"

Create with:

  kubectl apply -f ./pv-volume.yaml

Check results with:

  kubectl get pv task-pv-volume

2) Create a PersistentVolumeClaim: pv-claim.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi

Create the PersistentVolumeClaim: 

  kubectl apply -f ./pv-claim.yaml
  
 Check the results:
 
  kubectl get pv task-pv-volume

3) Create a Pod: spoondummy.yaml file:

apiVersion: v1
kind: Pod
metadata:
  name: podspoondummy
  labels:
    purpose: demo-spoon-job
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
  - name: demo-spoon-job
    image: cmolaro/spoon:v2.0
    command: ["/entrypoint.sh"]
    args: ["runt","sample/dummy.ktr"]
    volumeMounts:
      - mountPath: "/jobs"
        name: task-pv-storage
  restartPolicy: OnFailure
  
4) Execute:

  kubectl apply -f ./spoondummy.yaml

It gives:

  cris@x250:/work/docker/spoon$ kubectl apply -f ./spoondummy.yaml
  pod/podspoondummy created

Check:

  cris@x250:/work/docker/spoon$ kubectl get po
  NAME                         READY   STATUS              RESTARTS   AGE
  podspoondummy                0/1     ContainerCreating   0          33s
  cris@x250:/work/docker/spoon$

Note: it could take a while. Verify progress:




Check: 

  kubectl get pod podspoondummy --output=yaml

It gives:

  containerStatuses:
  - image: cmolaro/spoon:v2.0
    imageID: ""
    lastState: {}
    name: demo-spoon-job
    ready: false
    restartCount: 0
    started: false
    state:
      waiting:
        reason: ContainerCreating
  hostIP: 192.168.86.247
  phase: Pending
  qosClass: BestEffort
  startTime: "2021-05-04T17:49:09Z"

Then:

  kubectl describe pods podspoondummy

It gives:

Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  5m52s  default-scheduler  Successfully assigned default/podspoondummy to x250
  Normal  Pulling    5m51s  kubelet            Pulling image "cmolaro/spoon:v2.0"
  Normal  Pulled     94s    kubelet            Successfully pulled image "cmolaro/spoon:v2.0" in 4m16.731375883s
  Normal  Created    93s    kubelet            Created container demo-spoon-job
  Normal  Started    93s    kubelet            Started container demo-spoon-job

Check pod:

  cris@x250:/work/docker/spoon$ kubectl get pod podspoondummy
  NAME            READY   STATUS      RESTARTS   AGE
  podspoondummy   0/1     Completed   0          6m59s

Check logs:

  kubectl logs podspoondummy
  
It gives:

2021-05-04 19:53:50.763:INFO:oejsh.ContextHandler:features-3-thread-1: Started HttpServiceContext{httpContext=DefaultHttpContext [bundle=pentaho-webjars-angular [254], contextID=default]}
2021/05/04 19:53:53 - Start of run.
2021/05/04 19:53:53 - dummy - Dispatching started for transformation [dummy]
2021/05/04 19:53:53 - Carte - Installing timer to purge stale objects after 1440 minutes.
2021/05/04 19:53:53 - Finished!
2021/05/04 19:53:53 - Start=2021/05/04 19:53:53.154, Stop=2021/05/04 19:53:53.212
2021/05/04 19:53:53 - Processing ended after 0 seconds.
2021/05/04 19:53:53 - dummy -
2021/05/04 19:53:53 - dummy - Step Dummy (do nothing not at all).0 ended successfully, processed 0 lines. ( - lines/s)
