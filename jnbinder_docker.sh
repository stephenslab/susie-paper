alias jnbinder="mkdir -p docs && docker run --rm  -v $PWD:$PWD -v $PWD/docs:$PWD/docs -v /tmp:/tmp -v $PWD/.sos:$PWD/.sos-t -w=$PWD -u $UID:1000 gaow/jnbinder jnbinder"
