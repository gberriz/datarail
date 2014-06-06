function [] = nr_(seq)
    if istable(seq)
        n = height(seq);
        seq.Properties.RowNames = arraymap(@num2str, 1:n);
        todisp = seq;
    else
        n = length_(seq);
        fmt = sprintf('%%%dd\t%%s', floor(log10(n)) + 1);
        seq = tostr_(seq, n);
        lines = arraymap(@(i) sprintf(fmt, i, seq{i}), 1:n);
        todisp = strjoin(lines, '\n');
    end
    disp(todisp);
end

function out = tostr_(seq, n)
    bs = char(92); % backslash
    sq = char(39); % single quote

    function c = esc1_(c)
        if c == bs || c == sq; c = [bs c]; end
    end

    function c = esc2_(c)
        if c < 32 || c > 126; c = sprintf('%s%03o', bs, c); end
    end

    function out = esc_(s)
       e = CStr2String(arraymap(@esc1_, num2str(s)));
       out = CStr2String([{sq} arraymap(@esc2_, e) {sq}]);
    end

    seq = reshape(seq, n, []);

    if iscell(seq)
        out = arraymap(@(i) esc_(seq{i, :}), 1:n);
    else
        out = arraymap(@(i) esc_(seq(i, :)), 1:n);
    end
end
