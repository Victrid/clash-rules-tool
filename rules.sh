#!/bin/sh
cl_base_dir=$(dirname "$0")
cl_gencfg(){
rm -f $cl_base_dir/*.cfg.md
touch $cl_base_dir/proxy.cfg.md
touch $cl_base_dir/direct.cfg.md
echo "# Configuation for proxied entries
to enable a cfg file, please change [ ] to [x], vice versa." >> $cl_base_dir/proxy.cfg.md
echo "# Configuation for direct entries
to enable a cfg file, please change [ ] to [x], vice versa." >> $cl_base_dir/direct.cfg.md
for cfg in $cl_base_dir/proxy/*.cfg;
do
echo "  - [x] $cfg">> $cl_base_dir/proxy.cfg.md
done
for cfg in $cl_base_dir/direct/*.cfg;
do
echo "  - [x] $cfg">> $cl_base_dir/direct.cfg.md
done
}

cl_generate(){
rm -f $cl_base_dir/*.yaml
touch $cl_base_dir/proxy.yaml
touch $cl_base_dir/direct.yaml
echo 'payload:' > $cl_base_dir/proxy.yaml 
echo 'payload:' > $cl_base_dir/direct.yaml
if [ ! -f "$cl_base_dir/proxy.cfg.md"  ]&& [ ! -f "$cl_base_dir/direct.cfg.md" ]; then
    echo "Config file not found! Run $1 reset first!"
    exit 1
fi
for cfg in $({ echo $cl_base_dir/proxy/*.cfg | tr ' ' \\n; cat $cl_base_dir/proxy.cfg.md | sed -n '/-\s\[x\]/p' | sed 's/\s*-\s*\[x\]\s*//g';}  | sort | uniq -d | tr \\n ' ');
do
echo "  # from " ${cfg} ":" >> $cl_base_dir/proxy.yaml
cat $cfg | sed '/^\s*$/d;/^\s*#.*$/d' | sed 's/^\s*\([^\s]+\)\s*$/\1/g' | sed 's/^.*$/  - &/g'>> $cl_base_dir/proxy.yaml
done
for cfg in $({ echo $cl_base_dir/direct/*.cfg | tr ' ' \\n; cat $cl_base_dir/direct.cfg.md | sed -n '/-\s\[x\]/p' | sed 's/\s*-\s*\[x\]\s*//g';}  | sort | uniq -d | tr \\n ' ');
do
echo "  # from " ${cfg} ":" >> $cl_base_dir/direct.yaml
cat $cfg | sed '/^\s*$/d;/^\s*#.*$/d' | sed 's/^\s*\([^\s]+\)\s*$/\1/g' | sed 's/^.*$/  - &/g'>> $cl_base_dir/direct.yaml
done
}

cl_upload(){
. $cl_base_dir/config.sh
scp -P $cl_OpenClash_port $cl_base_dir/direct.yaml root@$cl_OpenClash_addr:/etc/openclash/rule_provider/direct.yaml
scp -P $cl_OpenClash_port $cl_base_dir/proxy.yaml root@$cl_OpenClash_addr:/etc/openclash/rule_provider/proxy.yaml
}

cl_help(){
echo "Usage: $0 {generate|generate_config|upload}"
}

case "$1" in 
    generate)
       cl_generate
       ;;
    generate_config)
       cl_gencfg
       ;;
    upload)
       cl_upload
       ;;
    *)
       cl_help
       ;;
esac

exit 0 
