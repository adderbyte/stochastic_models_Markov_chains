--------------------------
# Speech Processing , Machine Learning and Markov Models
---------------------------


The aim of this project is to develop key conceot in speech recognition. We build hidden Markov Models for speech recognition. Especially, we need to address 3 problems encountered in Markov Models:

  1. Given a sequence of observation sequence O<sub>1</sub>,O<sub>2</sub>... O<sub>T</sub> and a model <i>l</i> how do we efficiently compute the probability of the observation sequence given the model . (Solution :Forward Backward  Procedure)
  2. Given the observation sequence O<sub>1</sub>,O<sub>2</sub>... O<sub>T</sub> and the model <i>l</i> how do we choose a corresponding state sequence q<sub>1</sub>,q<sub>2</sub>... q<sub>T</sub> which is optimal in some meaningful sense?
  (Viterbi Algorithm)
  3. How do we we adjust the model parameters   <i>l</i> to maximise the observation sequence. (Expectation maximisation)
