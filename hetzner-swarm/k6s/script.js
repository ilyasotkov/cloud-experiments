import { check } from "k6";
import http from "k6/http";
import { Rate } from "k6/metrics";

export let errorRate = new Rate("errors");

export let options = {
  thresholds: {
    "errors": ["rate<0.1"], // <10% errors
  },
  stages: [
    { duration: "30s", target: 5 },
  ],
};

export default function() {
  let res = http.get("https://nginx-app.swarm.flexp.live/");
  errorRate.add(res.status != 200);
};
