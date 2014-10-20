
myvars = who;

for i=1:length(myvars)
    media = median(eval(myvars{i}(:,3)));
    mediaVect = ones(26,1)*media;
    plot(mediaVect);
    hold on;
    plot(eval(myvars{i}(:,3)));
end
