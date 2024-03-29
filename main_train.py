from IO import config as usr_config
from nn import config as nn_config
import ssl


def run():
    usr_configs = usr_config.get_usr_config()
    trainer_configs = nn_config.TrainerConfigs()
    trainer_configs.__setup__(usr_configs)
    trainer = nn_config.get_trainer(usr_configs.train)(trainer_configs)
    trainer.train()


if __name__ == '__main__':
    ssl._create_default_https_context = ssl._create_unverified_context
    run()
