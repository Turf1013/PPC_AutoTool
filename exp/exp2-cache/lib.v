
function integer LOG2 (
	input integer depth
);

	begin
		for (LOG2=0; depth>0; depth=depth+1)
			depth = depth >> 1;
	end

endfunction
