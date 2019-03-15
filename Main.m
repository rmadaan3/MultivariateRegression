Q = input('Enter file name:','s');
%%Input is being taken according to how easy does the data value can be handled by the method.
if strcmp(Q,'Concrete_Data.xls')==1 || strcmp(Q,'Folds5x2_pp.xlsx')==1
    T=xlsread(Q);
    Size = size(T,2);
    Y=T(:,Size);
    X=T(:,1:Size-1);
    %%Last column is the output.
elseif strcmp(Q,'forestfires.csv')==1 || strcmp(Q,'dataset_Facebook.csv')==1
    T=readtable(Q);
    Size = size(T,2);
    Row = size(T,1);
    if strcmp(Q,'forestfires.csv')==1
        Y=table2array(T(:,Size));
        X=table2array(T(:,[1:2 5:Size-1]));
        %%The 3rd & 4th columns are left out because
        %%they contain text data. Last column is the output.
    else
        Y=table2array(T([1:111 113:120 122:124 126:164 166:Row-1],Size));
        X=table2array(T([1:111 113:120 122:124 126:164 166:Row-1],[1 3:Size-1]));
        disp('This answer can vary from the actual answer due to high float precision error and very low values (of order -23)');
        %%Row Nos. 112,121,125,165,500 have atleast one of 
        %%the values in the row as empty which cannot be processed and thus
        %%has to be left out.
        %%Other than this, the second column is left out because
        %%it contains only text data. Last column is the output.
    end
else
    T=importdata(Q);
    if strcmp(Q,'slump_test.data')==1 || strcmp(Q,'flare.data2')==1 || strcmp(Q,'machine.data')==1 
        %%To remove text data.
        T = T.data;
    end
    Size = size(T,2);
    if strcmp(Q,'flare.data2')==1
        Y=T(:,Size-2:Size);
        X=T(:,1:Size-3);
        %%Last 3 columns are the output.
    elseif strcmp(Q,'slump_test.data')==1
        Y=T(:,Size-2:Size);
        X=T(:,2:Size-3);
        %%The 1st column is left out because it contains index data. Last 3 columns are the output.
    elseif strcmp(Q,'o-ring-erosion-only.data')==1 || strcmp(Q,'o-ring-erosion-or-blowby.data')==1
        Y=T(:,2);
        X=T(:,[1 Size-2:Size-1]);
        %%The 5th column is left out because it contains index data. 2nd column is the output.
    else
        Y=T(:,Size);
        X=T(:,1:Size-1);
        %%Last column is the output.
    end
end
Col = size(X,1);
YSize = size(Y,2);

for J = 1:YSize
    A = 0;
    for I = 1:Col
        if I == Col
            K = Y(1:Col-1,J);
            L = X(1:Col-1,:);
        elseif I == 1
            K = Y(2:Col,J);
            L = X(2:Col,:);
        else
            K = Y([1:I-1 I+1:Col],J);
            L = X([1:I-1 I+1:Col],:);
        end
        F = mldivide(L,K);
        Ktest = Y(I,J);
        Ltest = X(I,:);
        Exp = Ltest*F;
        B = (Exp-Ktest).^2;
        A=B+A;
    end
    disp(A);
end
