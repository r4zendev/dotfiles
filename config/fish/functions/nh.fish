function nh --description "nh with an init subcommand for dev-shell templates"
    if test "$argv[1]" = init
        set -l t $argv[2]
        if test -z "$t"
            echo "usage: nh init <node|bun|go|rust|python|zig|c|empty>"
            return 1
        end
        nix flake init -t ~/projects/dotfiles#$t
        and begin
            if not test -f .envrc
                printf 'use flake\ndotenv_if_exists .env\ndotenv_if_exists .env.local\n' >.envrc
            end
            direnv allow
        end
    else
        command nh $argv
    end
end
