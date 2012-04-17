function I = er_draw_line2(r1, c1, r2, c2, I, lineVal)
%
insize = size(I);
if (abs(r2-r1) > abs(c2-c1))
    for i = min(r1,r2):max(r1,r2)
	%if (i < 1 | i > size(I,1)) continue; end;
	if (i < 1) 
	    if (max(r1,r2) < 1) return; else i = 1; end;
	else 
	    if (i > size(I,1)) return; end
	end
	c = interp1([r1 r2], [c1 c2], round(i), 'spline');
	if (c < 1 | c > size(I,2)) continue; end
	I(round(i), round(c)) = lineVal;
    end
else
    for i = min(c1,c2):max(c1,c2)
	%if (i < 1 | i > size(I,2)) continue; end;
	if (i < 1)
	    if (max(c1,c2) < 1) return; else i = 1; end;
	else 
	    if (i > size(I,2)) return; end
	end
	r = interp1([c1 c2], [r1 r2], round(i), 'spline');
	if (r < 1 | r > size(I,1)) continue; end
	I(round(r), round(i)) = lineVal;
    end
end


