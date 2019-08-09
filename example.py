import kaldi_ivector as kiv
import os

M=4
num_gselect=2
ivector_dim=2*7

Ivector=kiv.kaldi_ivector()

PATH=os.path.dirname(os.path.abspath(__file__))

Ivector.train(PATH+'/example_data/example_train.scp',PATH+'/example_data/example_model',M,ivector_dim,num_gselect)
ivectors,keys=Ivector.extract(PATH+'/example_data/example_model/extractor', PATH+'/example_data/example_test.scp',PATH+'/example_data/ivectors',num_gselect)

print(ivectors.shape)
print(keys)