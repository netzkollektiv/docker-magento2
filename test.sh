phone_missing=true
if [ "$phone_missing" != false ]; then
    echo "phone_missing is not 'false' (but may be non-true, too)"
fi
if [ "$phone_missing" == true ]; then
    echo "phone_missing is true."
fi
