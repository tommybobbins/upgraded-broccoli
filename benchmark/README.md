# README #

## Build the esrally image

```
 gcloud auth print-access-token --quiet | podman login -u oauth2accesstoken --password-stdin europe-west2-docker.pkg.dev
 podman build -t europe-west2-docker.pkg.dev/<project>/benchmarking/esrally:0.1 .
# Or if running from non-intel hw
 podman build --arch x86_64 -t europe-west2-docker.pkg.dev/zeta-main-gcp/zeta/esrally:0.1 .
 podman push europe-west2-docker.pkg.dev/<project>/benchmarking/esrally:0.1
```

Ensure that the ~/.kube/config file has been populated.

## Race Results

```
$ kubectl attach esrally -c esrally -i -t
If you don't see a command prompt, try pressing enter.
/ # PASSWORD=u298NjD5YHK0w3fPm37kc64t
/ # esrally race --track=percolator --target-hosts=test-es-http.es-test.svc:9200 --pipeline=benchmark-only --client-options="use_ssl:true,verify_certs:false,basic_auth_user:'elastic',basic_auth_password:$PASSWORD"

    ____        ____
   / __ \____ _/ / /_  __
  / /_/ / __ `/ / / / / /
 / _, _/ /_/ / / / /_/ /
/_/ |_|\__,_/_/_/\__, /
                /____/

[INFO] Race id is [4a78c990-9032-4c1a-8f6d-44277606b8b4]
[INFO] Downloading track data (121.1 kB total size)                               [100.0%]
[INFO] Decompressing track data from [/root/.rally/benchmarks/data/percolator/queries-2.json.bz2] to [/root/.rally/benchmarks/data/percolator/queries-2.json] (resulting size: [0.10] GB) ... [OK]
[INFO] Preparing file offset table for [/root/.rally/benchmarks/data/percolator/queries-2.json] ... [OK]
[INFO] Racing on track [percolator], challenge [append-no-conflicts] and car ['external'] with version [8.8.1].

Running delete-index                                                           [100% done]
Running create-index                                                           [100% done]
Running check-cluster-health                                                   [100% done]
Running index                                                                  [100% done]
Running refresh-after-index                                                    [100% done]
Running force-merge                                                            [100% done]
Running refresh-after-force-merge                                              [100% done]
Running wait-until-merges-finish                                               [100% done]
Running percolator_with_content_president_bush                                 [100% done]
Running percolator_with_content_saddam_hussein                                 [100% done]
Running percolator_with_content_hurricane_katrina                              [100% done]
Running percolator_with_content_google                                         [100% done]
Running percolator_no_score_with_content_google                                [100% done]
Running percolator_with_highlighting                                           [100% done]
Running percolator_with_content_ignore_me                                      [100% done]
Running percolator_no_score_with_content_ignore_me                             [100% done]

------------------------------------------------------
    _______             __   _____
   / ____(_)___  ____ _/ /  / ___/_________  ________
  / /_  / / __ \/ __ `/ /   \__ \/ ___/ __ \/ ___/ _ \
 / __/ / / / / / /_/ / /   ___/ / /__/ /_/ / /  /  __/
/_/   /_/_/ /_/\__,_/_/   /____/\___/\____/_/   \___/
------------------------------------------------------
            
|                                                         Metric |                                       Task |           Value |   Unit |
|---------------------------------------------------------------:|-------------------------------------------:|----------------:|-------:|
|                     Cumulative indexing time of primary shards |                                            |     1.51198     |    min |
|             Min cumulative indexing time across primary shards |                                            |     0.269183    |    min |
|          Median cumulative indexing time across primary shards |                                            |     0.288783    |    min |
|             Max cumulative indexing time across primary shards |                                            |     0.350283    |    min |
|            Cumulative indexing throttle time of primary shards |                                            |     0           |    min |
|    Min cumulative indexing throttle time across primary shards |                                            |     0           |    min |
| Median cumulative indexing throttle time across primary shards |                                            |     0           |    min |
|    Max cumulative indexing throttle time across primary shards |                                            |     0           |    min |
|                        Cumulative merge time of primary shards |                                            |     0.251083    |    min |
|                       Cumulative merge count of primary shards |                                            |    10           |        |
|                Min cumulative merge time across primary shards |                                            |     0.0349      |    min |
|             Median cumulative merge time across primary shards |                                            |     0.0548167   |    min |
|                Max cumulative merge time across primary shards |                                            |     0.0632333   |    min |
|               Cumulative merge throttle time of primary shards |                                            |     0           |    min |
|       Min cumulative merge throttle time across primary shards |                                            |     0           |    min |
|    Median cumulative merge throttle time across primary shards |                                            |     0           |    min |
|       Max cumulative merge throttle time across primary shards |                                            |     0           |    min |
|                      Cumulative refresh time of primary shards |                                            |     0.14275     |    min |
|                     Cumulative refresh count of primary shards |                                            |   111           |        |
|              Min cumulative refresh time across primary shards |                                            |     0.0262667   |    min |
|           Median cumulative refresh time across primary shards |                                            |     0.0286167   |    min |
|              Max cumulative refresh time across primary shards |                                            |     0.0304833   |    min |
|                        Cumulative flush time of primary shards |                                            |     0.269333    |    min |
|                       Cumulative flush count of primary shards |                                            |    25           |        |
|                Min cumulative flush time across primary shards |                                            |     0.0502833   |    min |
|             Median cumulative flush time across primary shards |                                            |     0.05505     |    min |
|                Max cumulative flush time across primary shards |                                            |     0.0558333   |    min |
|                                        Total Young Gen GC time |                                            |     9.88        |      s |
|                                       Total Young Gen GC count |                                            |  3402           |        |
|                                          Total Old Gen GC time |                                            |     0           |      s |
|                                         Total Old Gen GC count |                                            |     0           |        |
|                                                     Store size |                                            |     0.119082    |     GB |
|                                                  Translog size |                                            |     2.56114e-07 |     GB |
|                                         Heap used for segments |                                            |     0           |     MB |
|                                       Heap used for doc values |                                            |     0           |     MB |
|                                            Heap used for terms |                                            |     0           |     MB |
|                                            Heap used for norms |                                            |     0           |     MB |
|                                           Heap used for points |                                            |     0           |     MB |
|                                    Heap used for stored fields |                                            |     0           |     MB |
|                                                  Segment count |                                            |    23           |        |
|                                    Total Ingest Pipeline count |                                            |     0           |        |
|                                     Total Ingest Pipeline time |                                            |     0           |      s |
|                                   Total Ingest Pipeline failed |                                            |     0           |        |
|                                                 Min Throughput |                                      index | 11381.3         | docs/s |
|                                                Mean Throughput |                                      index | 22158.5         | docs/s |
|                                              Median Throughput |                                      index | 23370.1         | docs/s |
|                                                 Max Throughput |                                      index | 28868.1         | docs/s |
|                                        50th percentile latency |                                      index |  1126.82        |     ms |
|                                        90th percentile latency |                                      index |  1620.03        |     ms |
|                                        99th percentile latency |                                      index |  2162.56        |     ms |
|                                       100th percentile latency |                                      index |  2338.38        |     ms |
|                                   50th percentile service time |                                      index |  1126.82        |     ms |
|                                   90th percentile service time |                                      index |  1620.03        |     ms |
|                                   99th percentile service time |                                      index |  2162.56        |     ms |
|                                  100th percentile service time |                                      index |  2338.38        |     ms |
|                                                     error rate |                                      index |     0           |      % |
|                                                 Min Throughput |     percolator_with_content_president_bush |    17.46        |  ops/s |
|                                                Mean Throughput |     percolator_with_content_president_bush |    19.7         |  ops/s |
|                                              Median Throughput |     percolator_with_content_president_bush |    19.7         |  ops/s |
|                                                 Max Throughput |     percolator_with_content_president_bush |    21.93        |  ops/s |
|                                        50th percentile latency |     percolator_with_content_president_bush |  4261.28        |     ms |
|                                        90th percentile latency |     percolator_with_content_president_bush |  4671.44        |     ms |
|                                        99th percentile latency |     percolator_with_content_president_bush |  4774.02        |     ms |
|                                       100th percentile latency |     percolator_with_content_president_bush |  4784.93        |     ms |
|                                   50th percentile service time |     percolator_with_content_president_bush |    32.0046      |     ms |
|                                   90th percentile service time |     percolator_with_content_president_bush |    38.0482      |     ms |
|                                   99th percentile service time |     percolator_with_content_president_bush |    50.2897      |     ms |
|                                  100th percentile service time |     percolator_with_content_president_bush |    56.9447      |     ms |
|                                                     error rate |     percolator_with_content_president_bush |     0           |      % |
|                                                 Min Throughput |     percolator_with_content_saddam_hussein |    49.84        |  ops/s |
|                                                Mean Throughput |     percolator_with_content_saddam_hussein |    49.85        |  ops/s |
|                                              Median Throughput |     percolator_with_content_saddam_hussein |    49.85        |  ops/s |
|                                                 Max Throughput |     percolator_with_content_saddam_hussein |    49.87        |  ops/s |
|                                        50th percentile latency |     percolator_with_content_saddam_hussein |    10.0949      |     ms |
|                                        90th percentile latency |     percolator_with_content_saddam_hussein |    13.732       |     ms |
|                                        99th percentile latency |     percolator_with_content_saddam_hussein |    26.7922      |     ms |
|                                       100th percentile latency |     percolator_with_content_saddam_hussein |    31.5259      |     ms |
|                                   50th percentile service time |     percolator_with_content_saddam_hussein |     8.69425     |     ms |
|                                   90th percentile service time |     percolator_with_content_saddam_hussein |    12.4248      |     ms |
|                                   99th percentile service time |     percolator_with_content_saddam_hussein |    25.4126      |     ms |
|                                  100th percentile service time |     percolator_with_content_saddam_hussein |    29.9205      |     ms |
|                                                     error rate |     percolator_with_content_saddam_hussein |     0           |      % |
|                                                 Min Throughput |  percolator_with_content_hurricane_katrina |    49.85        |  ops/s |
|                                                Mean Throughput |  percolator_with_content_hurricane_katrina |    49.87        |  ops/s |
|                                              Median Throughput |  percolator_with_content_hurricane_katrina |    49.87        |  ops/s |
|                                                 Max Throughput |  percolator_with_content_hurricane_katrina |    49.89        |  ops/s |
|                                        50th percentile latency |  percolator_with_content_hurricane_katrina |    15.4046      |     ms |
|                                        90th percentile latency |  percolator_with_content_hurricane_katrina |    26.7956      |     ms |
|                                        99th percentile latency |  percolator_with_content_hurricane_katrina |    30.9654      |     ms |
|                                       100th percentile latency |  percolator_with_content_hurricane_katrina |    36.3176      |     ms |
|                                   50th percentile service time |  percolator_with_content_hurricane_katrina |    13.7205      |     ms |
|                                   90th percentile service time |  percolator_with_content_hurricane_katrina |    20.4332      |     ms |
|                                   99th percentile service time |  percolator_with_content_hurricane_katrina |    26.7621      |     ms |
|                                  100th percentile service time |  percolator_with_content_hurricane_katrina |    35.2525      |     ms |
|                                                     error rate |  percolator_with_content_hurricane_katrina |     0           |      % |
|                                                 Min Throughput |             percolator_with_content_google |    13.76        |  ops/s |
|                                                Mean Throughput |             percolator_with_content_google |    13.89        |  ops/s |
|                                              Median Throughput |             percolator_with_content_google |    13.87        |  ops/s |
|                                                 Max Throughput |             percolator_with_content_google |    14.13        |  ops/s |
|                                        50th percentile latency |             percolator_with_content_google |  5386.03        |     ms |
|                                        90th percentile latency |             percolator_with_content_google |  6493.89        |     ms |
|                                        99th percentile latency |             percolator_with_content_google |  6726.46        |     ms |
|                                       100th percentile latency |             percolator_with_content_google |  6753.51        |     ms |
|                                   50th percentile service time |             percolator_with_content_google |    64.1833      |     ms |
|                                   90th percentile service time |             percolator_with_content_google |    82.3251      |     ms |
|                                   99th percentile service time |             percolator_with_content_google |   114.465       |     ms |
|                                  100th percentile service time |             percolator_with_content_google |   114.753       |     ms |
|                                                     error rate |             percolator_with_content_google |     0           |      % |
|                                                 Min Throughput |    percolator_no_score_with_content_google |    86.98        |  ops/s |
|                                                Mean Throughput |    percolator_no_score_with_content_google |    86.98        |  ops/s |
|                                              Median Throughput |    percolator_no_score_with_content_google |    86.98        |  ops/s |
|                                                 Max Throughput |    percolator_no_score_with_content_google |    86.98        |  ops/s |
|                                        50th percentile latency |    percolator_no_score_with_content_google |   267.842       |     ms |
|                                        90th percentile latency |    percolator_no_score_with_content_google |   300.205       |     ms |
|                                        99th percentile latency |    percolator_no_score_with_content_google |   304.307       |     ms |
|                                       100th percentile latency |    percolator_no_score_with_content_google |   304.31        |     ms |
|                                   50th percentile service time |    percolator_no_score_with_content_google |     8.4655      |     ms |
|                                   90th percentile service time |    percolator_no_score_with_content_google |    10.7603      |     ms |
|                                   99th percentile service time |    percolator_no_score_with_content_google |    14.2076      |     ms |
|                                  100th percentile service time |    percolator_no_score_with_content_google |    15.4544      |     ms |
|                                                     error rate |    percolator_no_score_with_content_google |     0           |      % |
|                                                 Min Throughput |               percolator_with_highlighting |    48.59        |  ops/s |
|                                                Mean Throughput |               percolator_with_highlighting |    48.77        |  ops/s |
|                                              Median Throughput |               percolator_with_highlighting |    48.77        |  ops/s |
|                                                 Max Throughput |               percolator_with_highlighting |    48.94        |  ops/s |
|                                        50th percentile latency |               percolator_with_highlighting |    13.1548      |     ms |
|                                        90th percentile latency |               percolator_with_highlighting |    17.1917      |     ms |
|                                        99th percentile latency |               percolator_with_highlighting |    24.6263      |     ms |
|                                       100th percentile latency |               percolator_with_highlighting |    28.2166      |     ms |
|                                   50th percentile service time |               percolator_with_highlighting |    11.8095      |     ms |
|                                   90th percentile service time |               percolator_with_highlighting |    15.7842      |     ms |
|                                   99th percentile service time |               percolator_with_highlighting |    17.8402      |     ms |
|                                  100th percentile service time |               percolator_with_highlighting |    26.9705      |     ms |
|                                                     error rate |               percolator_with_highlighting |     0           |      % |
|                                                 Min Throughput |          percolator_with_content_ignore_me |     0.08        |  ops/s |
|                                                Mean Throughput |          percolator_with_content_ignore_me |     0.08        |  ops/s |
|                                              Median Throughput |          percolator_with_content_ignore_me |     0.08        |  ops/s |
|                                                 Max Throughput |          percolator_with_content_ignore_me |     0.09        |  ops/s |
|                                        50th percentile latency |          percolator_with_content_ignore_me |  9259.97        |     ms |
|                                        90th percentile latency |          percolator_with_content_ignore_me |  9391.4         |     ms |
|                                        99th percentile latency |          percolator_with_content_ignore_me |  9489.33        |     ms |
|                                       100th percentile latency |          percolator_with_content_ignore_me |  9819.34        |     ms |
|                                   50th percentile service time |          percolator_with_content_ignore_me |  9257.08        |     ms |
|                                   90th percentile service time |          percolator_with_content_ignore_me |  9389.05        |     ms |
|                                   99th percentile service time |          percolator_with_content_ignore_me |  9486.99        |     ms |
|                                  100th percentile service time |          percolator_with_content_ignore_me |  9817.59        |     ms |
|                                                     error rate |          percolator_with_content_ignore_me |     0           |      % |
|                                                 Min Throughput | percolator_no_score_with_content_ignore_me |    15.04        |  ops/s |
|                                                Mean Throughput | percolator_no_score_with_content_ignore_me |    15.05        |  ops/s |
|                                              Median Throughput | percolator_no_score_with_content_ignore_me |    15.05        |  ops/s |
|                                                 Max Throughput | percolator_no_score_with_content_ignore_me |    15.06        |  ops/s |
|                                        50th percentile latency | percolator_no_score_with_content_ignore_me |     8.91552     |     ms |
|                                        90th percentile latency | percolator_no_score_with_content_ignore_me |    10.6061      |     ms |
|                                        99th percentile latency | percolator_no_score_with_content_ignore_me |    13.7953      |     ms |
|                                       100th percentile latency | percolator_no_score_with_content_ignore_me |    15.9596      |     ms |
|                                   50th percentile service time | percolator_no_score_with_content_ignore_me |     7.45409     |     ms |
|                                   90th percentile service time | percolator_no_score_with_content_ignore_me |     9.63583     |     ms |
|                                   99th percentile service time | percolator_no_score_with_content_ignore_me |    12.2359      |     ms |
|                                  100th percentile service time | percolator_no_score_with_content_ignore_me |    14.5581      |     ms |
|                                                     error rate | percolator_no_score_with_content_ignore_me |     0           |      % |


----------------------------------
[INFO] SUCCESS (took 1525 seconds)
----------------------------------
/ # 
Session ended, resume using 'kubectl attach esrally -c esrally -i -t' command when the pod is running
```
