#!/usr/bin/env python3

import configparser
import subprocess

config = configparser.ConfigParser()
config.read("./sqitch.conf")


def orchestrate_plan():
    """Orchestrate the deployment of migrations based on the orchestration plan."""

    plan_path = config["core"]["top_dir"] + "/orchestration.plan"
    prev_target = None
    prev_migration = None
    with open(plan_path) as f:
        for line in f:
            line = line.strip()

            # ignore empty lines and comments
            if not line or line.startswith("#"):
                continue
            items = line.split(":")
            if len(items) != 2:
                continue

            target, migration = items

            # find the last migration for each target
            if prev_target is None:
                prev_target = target
                prev_migration = migration
            elif target != prev_target:
                if prev_migration is not None and prev_target is not None:
                    subprocess.run(["./sqitch", "deploy", "--change", prev_migration, "--target", prev_target])
                prev_target = target
                prev_migration = migration
            else:
                prev_migration = migration

    # Print the last migration for the last target
    if prev_target is not None and prev_migration is not None:
        subprocess.run(["./sqitch", "deploy", "--change", prev_migration, "--target", prev_target])


if __name__ == "__main__":
    orchestrate_plan()
