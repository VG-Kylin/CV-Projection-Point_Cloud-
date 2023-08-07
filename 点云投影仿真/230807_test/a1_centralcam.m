clear ; clear;close all;
% 读取ply文件
filename = 'output2.ply';
ptCloud = pcread(filename);

% 将点云设置为红色
ptCloud.Color = repmat([1 0 0], ptCloud.Count, 1);

% 显示点云
figure

pcshow(ptCloud);
% hold on;
%% 原版
% 初始化相机
% Tcam = transl(-30,30,30) ...
%             *trotx(deg2rad(0))...
%             *troty(deg2rad(0)) ...
%             *trotx(deg2rad(90));
% % 设置参数
% cam = CentralCamera('focal', 0.00168,'pixel',2.7*10e-6, ...
%      'resolution',[400 400],'centre',[200 200],'pose',Tcam);
% world = SE3();
% trplot(world,'frame','0','color','b');
% 
% % plot camera
% cam.plot_camera();
% 
% % hold on;
% S1=ptCloud.Location;
% S = padarray(S1, [0 1], 1, 'post');
% K = padarray(cam.K, [0 1], 0, 'post');
% m=K*Tcam*S';
% mx=round(m(1,:)./m(3,:));
% my=round(m(2,:)./m(3,:));
% image = zeros(400, 400);
% for i = 1:size(mx, 2)
%     if mx(i) >= 1 && mx(i) <= 400 && my(i) >= 1 && my(i) <= 400
%         image(my(i), mx(i)) = 255; 
%     end
% end
% figure;
% imshow(image);


%% VG-TechCenter版本---机器视觉成像仿真

CMOSsize=[400	400];%相机分辨率
%机器视觉模型内参数矩阵
in=[5824.06524429238	    0	        0
            0	     5677.89876537966	0
            0	            0	               1];%都是像素单位[fx 0 u0;0 fy v0;0 0 1]，默认主点没有偏移


R=[1 0 0
    0 1 0 
    0 0 1 ];%相机旋转矩阵，无旋转为单位阵

T=[0 0 1000];%世界坐标系的相机位置（mm单位）

world_point=ptCloud.Location;

camera_points = R * world_point' + T';

 image_points = in*camera_points;
    image_points=image_points';
    [m,~]=size(image_points);
    image_points_norm=zeros(m,3);
    for i=1:m
        image_points_norm(i,:)=image_points(i,:)/image_points(i,3);
    end


 % 设置图形窗口的大小和位置
    width = 2000;   % 宽度（以像素为单位）
    height = 1600;  % 高度（以像素为单位）
    xPos = 0;    % 水平位置（以像素为单位）
    yPos = 0;    % 垂直位置（以像素为单位）
    set(figure, 'Position', [xPos, yPos, width, height]);
        plot(image_points_norm(:,1),image_points_norm(:,2),'b.');axis equal;%hold on;
        xlim([0, CMOSsize(1)]); % 设置 x 轴的范围
        ylim([0, CMOSsize(2)]);  % 设置 y 轴的范围
        xlabel('X');
        ylabel('Y');
        title('Photo-Imgpoints');
