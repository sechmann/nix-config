{ ... }:
{
  home.shellAliases = {
    base64 = "base64 --wrap=0";
    dc = "docker compose";
    froom = "xdg-open \"zoommtg://zoom.us/join?action=join&confno=4267640733&pwd=nais\"";
    g = "git";
    gi = "git";
    k = "kubectl";
    l = "eza --long --group --all";
    listening = "sudo lsof -PiTCP -sTCP:LISTEN";
    ls = "eza --color=always --long --git --no-filesize --icons --no-time --no-permissions --no-user";
    s = "git s";
    show_cert = "openssl x509 -noout -text -in";
    t = "tmux";
    tf = "terraform";
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    syntaxHighlighting.enable = true;
    history = {
      ignoreSpace = true;
    };
    profileExtra = ''
      # vim:ft=zsh

      _find_gcp_project_interactive() {
        all_projects="$(gcloud projects list --format=json)"
        tenants=$( (jq -r '.[] | .labels | select(has("tenant")) | .tenant' | sort | uniq) <<<"$all_projects")
        tenant="$(fzf --ansi -1 -q "$1" <<<"$tenants")"

        projects=$( (jq -r ".[] | select(.labels.tenant == \"$tenant\")|.projectId") <<<"$all_projects")
        project="$(fzf --ansi -1 -q "$1" <<<"$projects")"

        echo $project
      }

      gcp_find_project() {
        project="$(_find_gcp_project_interactive)"
        wl-copy -n <<<"$project"

        echo "$project copied to clipboard"
      }

      gp() {
        projects="$(gcloud projects list --format='value(project_id)')"
        project="$(fzf --ansi -1 -q "$1" <<<"$projects")"

        gcloud config set core/project "$project" --no-user-output-enabled
        if [ $? -eq 0 ]; then
          echo "set active gcloud project to $project"
        else
          echo "failed to set active project, please try to run the following manually"
          echo "gcloud config set core/project \"$project\""
        fi

        [ -n "$TMUX" ] && tmux refresh-client -S || true
      }

      gc() {
        accounts="$(gcloud auth list --format 'value(account)')"
        account="$(fzf --ansi -1 -q "$1" <<<"$accounts")"

        gcloud config set account "$account" --no-user-output-enabled
        if [ $? -eq 0 ]; then
          echo "set active gcloud account to $account"
        else
          echo "failed to set active account, please try to run the following manually"
          echo "gcloud config set account \"$account\""
        fi

        [ -n "$TMUX" ] && tmux refresh-client -S || true
      }

      kc () {
        kubectx $@
        [ -n "$TMUX" ] && tmux refresh-client -S || true
      }

      kns () {
        kubens $@
        [ -n "$TMUX" ] && tmux refresh-client -S || true
      }

      dev () {
        dirs=$(fd --type directory --exact-depth 2 --base-directory "$HOME/dev/" .)
        dir=$(fzf --ansi -1 -q "$1" <<< "$dirs")
        if [[ -n "$dir" ]]; then
          cd "$HOME/dev/$dir" || exit
        else
          echo "no dir specified"
        fi
      }

      gocover() {
        coverfile=$(mktemp)
        go test -coverprofile=$coverfile $@
        go tool cover -html=$coverfile
      }

      nc() {
        tenant=$(narc tenant list | fzf --ansi -1 -q "$1")
        filename=$(echo "''${tenant%.*}.yaml" | tr '[:upper:]' '[:lower:]') # lowercase

        if [[ -n "$tenant" ]]; then
          ln -sf "$HOME/.kube/tenants/$filename" "$HOME/.kube/config_tenant"
          narc tenant set "$tenant" && nais device connect
          [ -n "$TMUX" ] && tmux refresh-client -S || true
        else
          echo "no tenant selected"
        fi
      }

      console_db_connect() {
        project=$(_find_gcp_project_interactive)
        echo "project: $project"

        connection="$(gcloud --project="$project" sql instances list --format=json | jq -r '.[] | .connectionName' | fzf --ansi -1)"
        echo "instance: $connection"

        user_suffix="$(cut -d '.' -f 1 <<< $project).iam"
        echo "user_suffix: $user_suffix"

        sa="console@$project.iam.gserviceaccount.com"

        gcloud --project="$project" projects add-iam-policy-binding "$project" --member=user:vegar@nais.io --role=roles/iam.serviceAccountTokenCreator
        trap "gcloud --project=\"$project\" projects remove-iam-policy-binding \"$project\" --member=user:vegar@nais.io --role=roles/iam.serviceAccountTokenCreator && echo 'removed permissions'" EXIT

        # gcloud --project="$project" iam service-accounts add-iam-policy-binding "$sa" --member=user:vegar@nais.io --role=roles/iam.serviceAccountTokenCreator
          wl-copy -n <<< "psql -U \"console@$user_suffix\" -d console -h localhost -p 5433"
        echo "psql -U \"console@$user_suffix\" -d console -h localhost -p 5433"
        echo "psql command copied to clipboard"

        until cloud_sql_proxy --auto-iam-authn --impersonate-service-account "$sa" -p 5433 "$connection"; test $? -gt 128 && break; do
          echo "getting token creator role can take some time, retrying in 5s"
          sleep 5
        done
      }

      naisdevice_db_connect() {
        project=$(_find_gcp_project_interactive)
        echo "project: $project"

        connection="$(gcloud --project="$project" sql instances list --format=json | jq -r '.[] | .connectionName' | fzf --ansi -1)"
        echo "instance: $connection"

        db_user="apiserver"

        #gcloud --project="$project" projects add-iam-policy-binding "$project" --member=user:vegar@nais.io --role=roles/iam.serviceAccountTokenCreator
        #trap "gcloud --project=\"$project\" projects remove-iam-policy-binding \"$project\" --member=user:vegar@nais.io --role=roles/iam.serviceAccountTokenCreator && echo 'removed permissions'" EXIT

        db_password="$(gcloud compute --project "$project" ssh --zone=europe-north1-a --tunnel-through-iap naisdevice-apiserver -- sudo grep "DBCONNDSN" /etc/default/apiserver | cut -d ' ' -f 4 | cut -d '=' -f 2)"
        export PGPASSWORD="$db_password"
          wl-copy -n <<< " psql -U apiserver -d apiserver -h localhost -p 5433"
        echo "psql command copied to clipboard"

        until cloud_sql_proxy -p 5433 "$connection"; test $? -gt 128 && break; do
          echo "getting token creator role can take some time, retrying in 5s"
          sleep 5
        done
      }

      proxy_connect(){
        instance="$1"
        user="$2"
        db="$3"

        socket_dir=$(mktemp -d)

        cloud_sql_proxy -dir="$socket_dir/cloud_sql_sockets/" -projects nais-device -instances="$instance" &
        pid=$!
        sleep 5
        trap 'kill "$pid"; rm -rf "$socket_dir"' EXIT

        psql "sslmode=disable host=$socket_dir/cloud_sql_sockets/$instance user=$user dbname=$db"
      }

      bwauth() {
        bw unlock --raw | secret-tool store --label='Bitwarden session' bitwarden session
      }

      gauth() {
        local bw_session=$(secret-tool lookup bitwarden session)
        local user="''${1:-vegar@nais.io}"
        local pass

        pass=$(bw --session="$bw_session" list items --search 'google' | jq -r '.[] | select(.login.username == $ENV.user) | .login.password')
        echo -n "$pass" | gcloud auth login --update-adc "$user"
      }

      pr() {
        gh pr create -f && gh pr view --web
      }

      journalctllast() {
        unit="$1"
        journalctl _SYSTEMD_INVOCATION_ID="$(systemctl show --value -p InvocationID "$unit")" --no-hostname --output cat
      }
    '';
  };
}
