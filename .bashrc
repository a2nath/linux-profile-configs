if [ ! -f ~/.tmux/plugins/tpm/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
   
fi

if [ ! -f ~/.vim/colors/codedark.vim ]; then
    wget  -P ~/.vim/colors https://raw.githubusercontent.com/tomasiser/vim-code-dark/refs/heads/master/colors/codedark.vim
    echo "highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red" > ~/.vim/colors/vimdiff.vim
    echo "highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red" >> ~/.vim/colors/vimdiff.vim
    echo "highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red" >> ~/.vim/colors/vimdiff.vim
    echo "highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red" >> ~/.vim/colors/vimdiff.vim
fi
