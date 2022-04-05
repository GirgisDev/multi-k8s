const keys = require("./keys");
const redis = require("redis");

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
});

const sub = redisClient.duplicate();

let fibMemo = {};
function fib(index) {
  if (index < 2) return 1;
  else if (fibMemo[index]) return fibMemo[index];
  fibMemo[index] = fib(index - 1) + fib(index - 2);

  return fibMemo[index];
}

sub.on("message", (channel, message) => {
  redisClient.hset("values", message, fib(parseInt(message)))
})

sub.subscribe("insert");