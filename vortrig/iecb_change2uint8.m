function B = iecb_change2uint8( A )

if isuint8( A )
	B = uint8( A );
else
	B = A;
end
