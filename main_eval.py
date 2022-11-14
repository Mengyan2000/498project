import argparse

import torch
import ssl
import torch.nn as nn
from nn import config as nn_config


def quantize_weight(model):
    usr_configs = model.get('analysis').trainer_usr_configs
    print(usr_configs)

def main():
    parser = argparse.ArgumentParser(description='model evaluation script')
    parser.add_argument('model_src_path', type=str, help='model src path')
    args = parser.parse_args()

    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    # print(torch.cuda.is_available())
    ckpt = torch.load(args.model_src_path,map_location=device)
    
    usr_configs = ckpt.get('analysis').trainer_usr_configs
    usr_configs.train.result_dir = './'
    usr_configs.device.use_gpu = (device == 'cuda')
    usr_configs.train.train_model = False
    usr_configs.train.model_src_path = args.model_src_path
    # usr_configs.model.quant_model = True
    trainer_configs = nn_config.TrainerConfigs()
    
    trainer_configs.__setup__(usr_configs)     ## the function that calls get_model, quantization
    for name, layer in trainer_configs.model._modules.items():
        if isinstance(layer, nn.Sequential):
                for single_layer in layer:
                    if isinstance(single_layer, nn.Conv2d):
                        print("in main, after __Setup__: weight: ", single_layer.weight)
    # print("after trainer_config setup: ", trainer_configs.model)
    
    trainer = nn_config.get_trainer(usr_configs.train)(trainer_configs)
    # trainer = nn_config.get_trainer(trainer_configs.train)   ## trainer is a <nn.trainer.BackPropTrainer object
    # print("user config resume_from_best: ", trainer.trainer_configs.resume_from_best, "eval_model: ", trainer.trainer_configs.eval_model)
    for name, layer in trainer.trainer_configs.model._modules.items():
        if isinstance(layer, nn.Sequential):
                for single_layer in layer:
                    if isinstance(single_layer, nn.Conv2d):
                        print("in main, after get_trainer: weight: ", single_layer.weight)
    # trainer.trainer_configs.model = squeeze_net_10_way.pt.tar
    
    trainer.eval(trainer.trainer_configs.test_loader, print_acc=True, cfm=True)


if __name__ == '__main__':
    ssl._create_default_https_context = ssl._create_unverified_context
    main()
