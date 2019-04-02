#!/bin/bash

mfdir=$(dirname "$0")/..

if [[ ! -f ${mfdir}/search_dirs ]]
then
    echo "Error : ${mfdir}/search_dirs not existing"
    exit 1
fi

dr=$(cat ${mfdir}/search_dirs)

rm ${mfdir}/internal/auto_utils.mk
rm ${mfdir}/internal/auto_nodes.mk

touch ${mfdir}/internal/auto_utils.mk
touch ${mfdir}/internal/auto_nodes.mk

echo
echo "Updating MFTK utilities and nodes : "
echo

for d in ${dr}
do

    first_letter=${d:0:1}

    if [ "${first_letter}" != "/" ]
    then

        echo "Error ${d} is a relative path;"
        exit 1

    fi

    if [ -d "${d}" ]
    then

        echo "Searching directory ${d}"

        entries=$(find ${d}/ -maxdepth 2 -name "*.mfu")

        if test "${entries}"
        then

            echo "Utility entries found"

            for e in ${entries}
            do

                fname=${e##*/}
                name=${fname%.mfu}

                if test -z "$(cat ${mfdir}/internal/auto_utils.mk | grep ${e})"
                then

                    echo "Registering utility ${name}"

                    echo '$(eval $(call UTIL_REGISTER,'${name},${e}'))' >> ${mfdir}/internal/auto_utils.mk

                else
                    echo "Skipping registered utility ${name}"
                fi

            done

        else

            echo "No utility entries found"

        fi


        entries=$(find ${d}/ -maxdepth 2 -name "*.mfn")

        if test ${entries}
            then

            echo "Node entries found"

            for e in "${entries}"
            do

                fname=${e##*/}
                name=${fname%.mfn}

                if test -z "$(cat ${mfdir}/internal/auto_nodes.mk | grep ${e})"
                then

                    echo "Registering node ${name}"

                    echo '$(eval $(call NODE_REGISTER,'${name},${e}'))' >> ${mfdir}/internal/auto_nodes.mk
                else

                    echo "Skipping registered node ${name}"

                fi

            done

        else

            echo "No node entries found"
        fi

        echo

    else

        echo "Skipping non-existing directory ${d}"
        echo

    fi

done
