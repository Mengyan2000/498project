"""
Author: Rex Geng

quantization API for FX training

todo: you can use this template to write all of your quantization code
"""

import functools

import torch
import torch.nn as nn
import numpy as np
from nn.modules import Fire


def quantize_model(model, args):
    """
    generate a quantized model
    :param model:
    :param args:
    :return:
    """
    # SqueezeNet model has two Sequential layer, features and classifier
    # Features layer has one Conv2D layer and 8 Fire module
    # classifier has 1 Conv2D layer only
    B_w = 7
    with torch.no_grad():
        for name, layer in model._modules.items():
            if isinstance(layer, nn.Sequential):
                    for single_layer in layer:
                        if isinstance(single_layer, nn.Conv2d):
                            print("in quantization, after torch.load: weight: ", single_layer.weight)
        for name, layer in model._modules.items():
            if isinstance(layer, nn.Sequential):
                for single_layer in layer:
                    if isinstance(single_layer, nn.Conv2d):     ### if the layer is conv2d inside Sequential
                        print("inside quantize_model:: ", name, single_layer)
                        ### exchanging the max and min quantize level to be symmetrical around 0
                        weight_min = torch.min(single_layer.weight).detach().numpy()
                        weight_max = torch.max(single_layer.weight).detach().numpy()
                        if np.abs(weight_min) > np.abs(weight_max):
                            weight_max = 0-weight_min
                        else:
                            weight_min = 0-weight_max
                        quantize_level = np.arange(weight_min, weight_max, 2*weight_max/np.power(2, B_w))
                        quantize_level_tensor = torch.tensor(quantize_level)
                        # print("inside one layer: quantize level: ", quantize_level, " and weight: ", single_layer.weight)
                        for i in range(len(single_layer.weight)):
                            for j in range(len(single_layer.weight[i])):
                                for a in range(len(single_layer.weight[i][j])):
                                    for b in range(len(single_layer.weight[i][j][a])):
                                        single_layer.weight[i][j][a][b] = quantize_level_tensor[torch.argmin(torch.abs(single_layer.weight[i][j][a][b]-quantize_level_tensor))]
                        # print("affter quenatization, weight: ", single_layer.weight)
                    if isinstance(single_layer, Fire):
                        for fire_module_name, fire_module_layer in single_layer._modules.items():
                            if isinstance(fire_module_layer, nn.Conv2d):
                                print("inside quentize_model: fire_conv2d- ", fire_module_layer)
                                ### exchanging the max and min quantize level to be symmetrical around 0
                                weight_min = torch.min(fire_module_layer.weight).detach().numpy()
                                weight_max = torch.max(fire_module_layer.weight).detach().numpy()
                                if np.abs(weight_min) > np.abs(weight_max):
                                    weight_max = 0-weight_min
                                else:
                                    weight_min = 0-weight_max
                                quantize_level = np.arange(weight_min, weight_max, 2*weight_max/np.power(2, B_w))
                                quantize_level_tensor = torch.tensor(quantize_level)
                                for i in range(len(fire_module_layer.weight)):
                                    for j in range(len(fire_module_layer.weight[i])):
                                        for a in range(len(fire_module_layer.weight[i][j])):
                                            for b in range(len(fire_module_layer.weight[i][j][a])):
                                                fire_module_layer.weight[i][j][a][b] = quantize_level_tensor[torch.argmin(torch.abs(fire_module_layer.weight[i][j][a][b]-quantize_level_tensor))]
    return model


def rsetattr(obj, attr, val):
    pre, _, post = attr.rpartition('.')
    return setattr(rgetattr(obj, pre) if pre else obj, post, val)


def rgetattr(obj, attr, *args):
    def _getattr(obj, attr):
        return getattr(obj, attr, *args)

    return functools.reduce(_getattr, [obj] + attr.split('.'))


def quantize_uniform(data, n_bits, clip, device='cuda'):
    w_c = data.clamp(-clip, clip)
    b = torch.pow(torch.tensor(2.0), 1 - n_bits).to(device)
    w_q = clip * torch.min(b * torch.round(w_c / (b * clip)), 1 - b)

    return w_q


def quantize_act(data, n_bits, clip, device='cuda'):
    d_c = data.clamp(0, clip)
    b = torch.pow(torch.tensor(2.0), -n_bits).to(device)
    d_q = clip * torch.min(b * torch.round(d_c / (b * clip)), 1 - b)

    return d_q


class QSGD(torch.optim.SGD):
    def __init__(self, *kargs, **kwargs):
        super(QSGD, self).__init__(*kargs, **kwargs)

    def step(self, closure=None):
        for group in self.param_groups:
            for p in group['params']:
                if hasattr(p, 'org'):
                    p.data.copy_(p.org)
        super(QSGD, self).step()
        for group in self.param_groups:
            for p in group['params']:
                if hasattr(p, 'org'):
                    p.org.copy_(p.data)


class QAdam(torch.optim.Adam):
    def __init__(self, *kargs, **kwargs):
        super(QAdam, self).__init__(*kargs, **kwargs)

    def step(self, closure=None):
        for group in self.param_groups:
            for p in group['params']:
                if hasattr(p, 'org'):
                    p.data.copy_(p.org)
        super(QAdam, self).step()
        for group in self.param_groups:
            for p in group['params']:
                if hasattr(p, 'org'):
                    p.org.copy_(p.data)


class QConv2d(nn.Conv2d):
    def __init__(self, quant_scheme='TWN', quant_args=None, init_args=None, *kargs, **kwargs):
        super(QConv2d, self).__init__(*kargs, **kwargs)

    def forward(self, inputs):
        return inputs

    def quantize_params(self):
        return


class QLinear(nn.Linear):
    def __init__(self, quant_scheme, quant_args=None, init_args=None, *kargs, **kwargs):
        super(QLinear, self).__init__(*kargs, **kwargs)

    def forward(self, inputs):
        return inputs

    def quantize_params(self):
        return
