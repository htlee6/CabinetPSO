function [x0,y0,TCmin,interation]=gravity(x,y,V,f)
len_x=length(x);
len_y=length(y);
len_V=length(V);
len_f=length(f);
%��ʼ���õ��������ͱ���
d=[];
xw=[0];
yw=[0];
TC=[];
sigma_C=0;
temp_d=[];
denominator=0;
xw_numerator=0;
yw_numerator=0;
%���ӳ���³���ԣ��ж��������ȣ���֤�ڴ������������³��򲻻��������
if len_f==len_V && len_x == len_y && len_x == len_V
    %������Զ���ĳ�ʼֵ
    accuracy=input('Write Down The Accuracy:');
    xw(1)=input('Write Down The Initial X-coordinate:');
    yw(1)=input('Write Down The Initial Y-coordinate:');
    k=1;
    %����������㲿��
    while 1
        if k==1
            for j=1:len_x
                temp_d=[temp_d,distance(x(j),y(j),xw(k),yw(k))];
            end
            d=[d;temp_d];
            temp_d=[];
            %TC Cauculation
            sigma_C=0;
            for i=1:len_x
                temp=f(i)*V(i)*d(k,i);
                sigma_C=sigma_C+temp;
            end
            TC=[TC,sigma_C];
        end
        if k>1
            for p=1:len_x
                %2 denominators are the same
                denominator=denominator+f(p)*V(p)/d(k-1,p);
                %numerator of xw
                xw_numerator=xw_numerator+f(p)*V(p)*x(p)/d(k-1,p);
                %numerator of yw
                yw_numerator=yw_numerator+f(p)*V(p)*y(p)/d(k-1,p);
                
            end
            xw=[xw,xw_numerator/denominator];
            yw=[yw,yw_numerator/denominator];
            denominator=0;
            xw_numerator=0;
            yw_numerator=0;
            for j=1:len_x
                temp_d=[temp_d,distance(x(j),y(j),xw(k),yw(k))];
            end
            d=[d;temp_d];
            temp_d=[];
            %TC Cauculation
            sigma_C=0;
            for i=1:len_x
                temp=f(i)*V(i)*d(k,i);
                sigma_C=sigma_C+temp;
            end
            TC=[TC,sigma_C];
            if abs(TC(k-1)-TC(k)) <= accuracy
                break
            end
        end
        %��������+1
        k=k+1;
    end
else
    fprintf('Exception! Four arrays differs in length. \n')
end
x0=xw(k);
y0=yw(k);
TCmin=TC(k);
interation=k-1;
%���������
fprintf('------------------------------------------\n')
fprintf('The Final Result is:\n')
fprintf('------------------------------------------\n')
fprintf('X-coordinate:%f                                  \n',x0)
fprintf('Y-coordinate:%f                                  \n',y0)
fprintf('Lowest Cost :%f                                \n',TCmin)
fprintf('Interations :%d                                \n',interation)
fprintf('------------------------------------------\n')

end

%����һ������ŷʽ�����distance�Ӻ���
function dist=distance(x,y,x0,y0)
dist=sqrt((x-x0)^2+(y-y0)^2);
end
