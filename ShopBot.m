clear
%%%% INPUT %%%%
DT = 100;%[ms], time interval for each pause
x_dist = 5;%[mm] 
y_dist = 5;%[mm]
length_tank = 50;%[mm], length of tank
x_position = 0;
y_position = 0;
maxHeight = 10;%[mm], height of tank

fid = fopen('LDV_Gcode.sbp', 'wt');

fprintf(fid, 'N1 G91\n'); %Relative Coordinates

for i=1:((length_tank/x_dist)*2*(maxHeight+2))
    fprintf(fid, 'N%d ', i+1);
    if mod(i,2) == 0
      fprintf(fid, 'G04 P%d\n', DT);
    else
      x_position = x_position + x_dist;
      if x_position >= length_tank+1
          fprintf(fid, 'G01 X%d ',(-1*length_tank));
          fprintf(fid, 'Y%d\n', y_dist);
          x_position = 0;
          y_position = y_position + y_dist;
      else 
          fprintf(fid, 'G01 X%d\n',x_dist); 
      end
      
    end
end

fclose(fid);



