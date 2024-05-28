# NMF-CQT
The main program is an m file named main_matrix3. m, with the main difference being the construction of different graph adjacency matrices (different matrix construction methods are located in the folder "matrix_make")
Taking main_matrix3. m as an example
1 In the program, a result was obtained after NMF using GFT CQT STFT as the feature processing method.

2 Firstly, read clean speech data and perform three transformations (GFT CQT STFT). Perform NMF on a certain amount of clean speech data to obtain the base matrix W and coefficient matrix H after NMF under different feature transformations

3 Afterwards, we will enhance the noisy speech with multiple for loops in logic:
a) Firstly, read a noisy data, perform three transformations on it, and then perform NMF to obtain the basis matrix and coefficient matrix corresponding to the noise

b) By combining clean speech and noisy speech matrices, noisy speech enhancement can be performed on this basis

c) Afterwards, we will enhance different noisy speech with the same noise but different signal-to-noise ratios, and then obtain the evaluation results (pesq stoi)

4 The final evaluation result (PESQ STOI) is saved in the corresponding. mat file.

Citation
-----------------------------------------------
Please cite the following if our paper or code is helpful to your research.

@article{xu2021speech,
  title={Speech enhancement based on nonnegative matrix factorization in constant-Q frequency domain},
  author={Xu, Longting and Wei, Zhilin and Zaidi, Syed Faham Ali and Ren, Bo and Yang, Jichen},
  journal={Applied Acoustics},
  volume={174},
  pages={107732},
  year={2021},
  publisher={Elsevier}
}
