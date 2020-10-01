[corrupted_signal, K, N, total_iterations, x, signal] = config();
%%QE methods
rho = 2.25;
QE_Gamma =0.98;
tensor_iterations = total_iterations + 1200;
[X_nothing, y_nothing, Norm_nothing, iterations_nothing, converged_nothing] = QEnothingADMM(corrupted_signal, K, rho, total_iterations, QE_Gamma);
[X_tensor, y_tensor, Norm_tensor, iterations_tensor, converged_tensor] = QEtensorADMM(corrupted_signal, K, rho, tensor_iterations, QE_Gamma);
[X_all, y_all, Norm_all, iterations_all, converged_all] = QEallADMM(corrupted_signal, K, rho, total_iterations, QE_Gamma);

iter = total_iterations/5;
numLambda=500;
Hf = Hank(corrupted_signal,N);
right = norm(Hf);

lambdaNothing = getLambdaNothing(right,corrupted_signal,K,rho,iter,numLambda);
lambdaTensor = getLambdaTensor(right,corrupted_signal,K,rho,iter,numLambda);
lambdaAll = getLambdaAll(right,corrupted_signal,K,rho,iter,numLambda);

[X_nothingNN, y_nothingNN, Norm_nothingNN, iterations_nothingNN, converged_nothingNN ] = NNnothingADMM(corrupted_signal, rho, total_iterations, lambdaNothing);
[X_tensorNN, y_tensorNN, Norm_tensorNN, iterations_tensorNN, converged_tensorNN ] = NNtensorADMM(corrupted_signal, rho, tensor_iterations, lambdaTensor);
[X_allNN, y_allNN, Norm_allNN, iterations_allNN, converged_allNN ] = NNallADMM(corrupted_signal, rho, total_iterations, lambdaAll);

[X_nothingHC, y_nothingHC, Norm_nothingHC, iterations_nothingHC, converged_nothingHC ] = HCnothingADMM(corrupted_signal, K, rho, total_iterations);
[X_tensorHC, y_tensorHC, Norm_tensorHC, iterations_tensorHC, converged_tensorHC ] = HCtensorADMM(corrupted_signal, K, rho, tensor_iterations);
[X_allHC, y_allHC, Norm_allHC, iterations_allHC, converged_allHC ] = HCallADMM(corrupted_signal, K, rho, total_iterations);


%%helpers function to get misfit norm
misfitNorm = @(x1)norm(x1-corrupted_signal)/norm(y_all-corrupted_signal);

Name={'X_nothing';'X_tensor';'X_all';'X_nothingNN';'X_tensorNN';'X_allNN';'X_nothingHC';'X_tensorHC';'X_allHC';};
Rank=[0;0;0;0;0;0;0;0;0]+[rank(X_nothing); rank(X_tensor); rank(X_all); rank(X_nothingNN);rank(X_tensorNN);rank(X_allNN);rank(X_nothingHC);rank(X_tensorHC);rank(X_allHC)];
Misfit=[0;0;0;0;0;0;0;0;0]+[misfitNorm(y_nothing); misfitNorm(y_tensor); misfitNorm(y_all); misfitNorm(y_nothingNN);misfitNorm(y_tensorNN);misfitNorm(y_allNN);misfitNorm(y_nothingHC);misfitNorm(y_tensorHC);misfitNorm(y_allHC)];
Converged=[0;0;0;0;0;0;0;0;0]+[converged_nothing; converged_tensor; converged_all; converged_nothingNN;converged_tensorNN;converged_allNN;converged_nothingHC;converged_tensorHC;converged_allHC];
convRate=[0;0;0;0;0;0;0;0;0]+[iterations_nothing; iterations_tensor; iterations_all; iterations_nothingNN;iterations_tensorNN;iterations_allNN;iterations_nothingHC;iterations_tensorHC;iterations_allHC];

%%can't remember what this line was doing so commented out
%%Rank=Rank/total_iterations;Misfit=Misfit/total_iterations;Converged=Converged/total_iterations;convRate=convRate/total_iterations;

T=table(Name,Rank,Misfit,Converged,convRate);
T;
%%nothing
figure('Name','nothing')
plot(x,y_nothing,x,y_nothingNN,x,y_nothingHC,x,signal,x,corrupted_signal)
legend('Stransform','L1','Hard Chopping','original signal','signal with noise')
%%tensor weights
figure('Name','weights')
plot(x,y_tensor,x,y_tensorNN,x,y_tensorHC,x,signal,x,corrupted_signal)
legend('Stransform','L1','Hard Chopping','original signal','signal with noise')
%%all
figure('Name','all')
plot(x,y_all,x,y_allNN,x,y_allHC,x,signal,x,corrupted_signal)
legend('Stransform','L1','Hard Chopping','original signal','signal with noise')

%%nothing
figure('Name','S Transform nothing')
plot(x,y_nothing,x,signal,x,corrupted_signal)
legend('Stransform','original signal','signal with noise')
%%tensor weights
figure('Name','S Transform weights')
plot(x,y_tensor,x,signal,x,corrupted_signal)
legend('Stransform','original signal','signal with noise')
%%all
figure('Name','S Transform all')
plot(x,y_all,x,signal,x,corrupted_signal)
legend('Stransform','original signal','signal with noise')
