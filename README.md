Template for neural network development

To train a neural network from scratch,

run the following command: "python main_train.py yaml/squeeze_cifar10.yaml"

The script will generate a pt.tar file that contains:
- model state
- optimizer state
- learning rate scheduler state
- training&testing accuracy evolution

To evaluate the generated model, run:

"python main_eval.py C:\Users\mengy\Documents\University\ECE498\Final_project\squeeze_net_10_way_aug.pt.tar file"

Since the given model is already trained, you just need to run the command for model evaluation
