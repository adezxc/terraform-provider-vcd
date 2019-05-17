#!/usr/bin/env bash

if [ ! -d ./vcd ]
then
    echo "source directory ./vcd not found"
    exit 1
fi

wanted=$1

if [ -n "$DRY_RUN" ]
then
    VERBOSE=1
fi

accepted="[short acceptance multiple]"
if [ -z "$wanted" ]
then
    echo "Syntax: test TYPE"
    echo "    where TYPE is one of $accepted"
    exit 1
fi

# Adding some aliases to the accepted methods
if [ "$wanted" == "multi" ]
then
    wanted=multiple
fi
if [ "$wanted" == "acc" ]
then
    wanted=acceptance
fi

# Run test
echo "==> Run test $wanted"

cd vcd

function check_for_config_file {
    config_file=vcd_test_config.json
    if [ -n "${VCD_CONFIG}" ]
    then
        echo "Using configuration file from variable \$VCD_CONFIG"
        config_file=$VCD_CONFIG
    fi
    if [ ! -f $config_file ]
    then
        echo "ERROR: test configuration file $config_file is missing"; \
        exit 1
    fi

}

function unit_test {
    if [ -n "$VERBOSE" ]
    then
        echo " go test -i ${TEST} || exit 1"
        echo "VCD_SHORT_TEST=1 go test -tags unit -v -timeout 3m ."
    fi
    if [ -z "$DRY_RUN" ]
    then
        go test -i ${TEST} || exit 1
        go test -tags unit -v -timeout 3m .
    fi
}

function short_test {
    if [ -n "$VERBOSE" ]
    then
        echo " go test  -i ${TEST} || exit 1"
        echo "VCD_SHORT_TEST=1 go test -tags functional -v -timeout 3m ."
    fi
    if [ -z "$DRY_RUN" ]
    then
        go test -i ${TEST} || exit 1
        VCD_SHORT_TEST=1 go test -tags functional -v -timeout 3m .
    fi
}

function acceptance_test {
    tags="$1"
    if [ -z "$tags" ]
    then
        tags=functional
    fi
    if [ -n "$VERBOSE" ]
    then
        echo "# check for config file"
        echo "TF_ACC=1 go test -tags '$tags' -v -timeout 60m ."
    fi

    if [ -z "$DRY_RUN" ]
    then
        check_for_config_file
        TF_ACC=1 go test -tags "$tags" -v -timeout 60m .
    fi
}

function multiple_test {
    filter=$1
    if [ -z "$filter" ]
    then
        filter='TestAccVcdV.pp.*Multi'
    fi
    if [ -n "$VERBOSE" ]
    then
        echo "# check for config file"
        echo "TF_ACC=1 go test -v -timeout 60m -tags 'api multivm multinetwork' -run '$filter' ."
    fi

    if [ -z "$DRY_RUN" ]
    then
        check_for_config_file
        TF_ACC=1 go test -v -timeout 60m -tags 'api multivm multinetwork' -run "$filter" .
    fi
}

case $wanted in
    unit)
        unit_test
        ;;
    short)
        short_test
        ;;
    acceptance)
        acceptance_test functional
        ;;
    multinetwork)
        multiple_test TestAccVcdVappNetworkMulti
        ;;
    multiple)
        multiple_test
        ;;
    catalog)
        acceptance_test catalog
        ;;
    vapp)
        acceptance_test vapp
        ;;
    vm)
        acceptance_test vm
        ;;
    network)
        acceptance_test network
        ;;
    gateway)
        acceptance_test gateway
        ;;
    extnetwork)
        acceptance_test extnetwork
        ;;
    *)
        echo "Unhandled testing method $wanted"
        echo "Accepted methods: $accepted"
        exit 1
esac
