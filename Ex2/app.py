import os

def main():
    env_var = os.getenv('MY_ENV_VAR', 'User')
    print('Hello, ' + env_var + '!')
    print('Great Success!')

if __name__ == "__main__":
    main()

