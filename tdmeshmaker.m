% x = [1,-1,1,1,-1,-1,-1,1];
% y = [1,1,-1,1,-1,-1,1,-1];
% z = [1,1,1,-1,-1,1,-1,-1];
% vertices = [x',y',z'];
% plot3(x,y,z,marker='.',markersize=10,linestyle='none')
% % % csvwrite('data.csv', data);
% % 
% % faces = [
% %     1,2,3,4;
% %     ];
% 
% % vertices = [
% %     0,0;
% %     1,0;
% %     1,1;
% %     0,1];
% 
% faces = [
%     1,2,3,5];
% 
% patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);

vertices = [
    1,1,1;
    -1,1,1;
    1,-1,1;
    1,1,-1;
    -1,-1,-1;
    -1,-1,1;
    -1,1,-1;
    1,-1,-1;
    0,0,0];

faces = [1,2,6,3;
    3,6,5,8;
    1,3,8,4;
    1,2,7,4;
    4,7,5,8];

writeOBJ('patchtest.obj',vertices,faces)

% 
% points = [x(:), y(:), z(:)]; % Combine x, y, z into a single matrix
% DT = delaunayTriangulation(points);
% 
% % Plot the tetrahedral mesh with single color
% % figure;
% % tetramesh(DT, 'FaceColor', 'cyan', 'EdgeColor', 'k'); % 'none' for no edge color
% % title('Delaunay Triangulation');
% % xlabel('X');
% % ylabel('Y');
% % zlabel('Z');
% 
% % Convert to triangular mesh
% tri = DT.freeBoundary();
% 
% % Plot the triangular mesh
% figure;
% trisurf(tri, DT.Points(:,1), DT.Points(:,2), DT.Points(:,3), 'FaceColor', 'cyan', 'EdgeColor', 'none');
% title('Delaunay Triangulation');
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% 
% 
% % Write data to OBJ file
% filename = 'delaunay_mesh.obj';
% writeOBJ(filename, DT.Points, tri);
% 
% 
% 
% function writeOBJ(filename, vertices, faces)
%     fid = fopen(filename, 'w');
%     fprintf(fid, 'g Delaunay Triangulation\n');
% 
%     % Write vertices
%     fprintf(fid, '# Vertices\n');
%     fprintf(fid, 'v %.6f %.6f %.6f\n', vertices');
% 
%     % Write faces
%     fprintf(fid, '# Faces\n');
%     fprintf(fid, 'f %d %d %d\n', faces');
% 
%     fclose(fid);
% end

function writeOBJ(filename, vertices, faces)
    % Open file for writing
    fid = fopen(filename, 'w');
    
    % Write vertices
    for i = 1:size(vertices, 1)
        fprintf(fid, 'v %f %f %f\n', vertices(i, 1), vertices(i, 2), vertices(i, 3));
    end
    
    % Write faces
    for i = 1:size(faces, 1)
        fprintf(fid, 'f %d %d %d %d\n', faces(i, 1), faces(i, 2), faces(i, 3),faces(i, 4));
    end
    
    % Close file
    fclose(fid);
end
