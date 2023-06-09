import "dotenv/config";
import { task, HardhatUserConfig } from "hardhat/config";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-web3";
import "hardhat-gas-reporter";
import "hardhat-tracer";
import { hardhatDefaultConfig } from "@defi.org/web3-candies/dist/hardhat";
import _ from "lodash";

task("foo", async () => {});

export default _.merge(hardhatDefaultConfig(), {
  networks: {
    hardhat: {},
  },
  mocha: {
    bail: false,
  },
} as HardhatUserConfig);
