function b = writeiontophoresistable2(pathname, iontTable)

b = 0;

fidI = fopen([pathname 'iontophoresis_instruction.txt'],'w');
if ~isempty(fidI),
	for i=1:size(iontTable,1),
		fprintf(fidI,['%d,%4.4f,%4.4f,%4.4f,%4.4f,%d'],...
            iontTable(i,1),iontTable(i,2),iontTable(i,3),10000*iontTable(i,4),10000*iontTable(i,5),iontTable(i,6));
		fwrite(fidI,13,'char'); fwrite(fidI,10,'char');
	end;
	fclose(fidI);
    b = 1;
end;
