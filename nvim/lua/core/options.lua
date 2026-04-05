local opt          = vim.opt

opt.number         = true  -- Показать номера строк
opt.relativenumber = true  -- Показать строки относительно текущей
opt.signcolumn     = "yes" -- Показывать колонку знков всегда
opt.cursorline     = true  -- Вулючить подсветкустроки
opt.numberwidth    = 2
opt.statuscolumn   = "%s%=%{v:relnum == 0 ? v:lnum : v:relnum}   "

opt.tabstop        = 4             -- Сколько пробелов занимает таб при отображении
opt.softtabstop    = 4             -- Сколько пробелов вставлять при нажатии Tab в режиме вставки
opt.shiftwidth     = 4             -- На сколько пробелов сдвигать код при командах >> и <<
opt.expandtab      = true          -- Превращать табы в пробелы (true) или оставлять табами (false)

opt.mouse          = "a"           -- Включить мышь во всех режимах:
opt.mousescroll    = "ver:3,hor:1" -- Быстрый скролл мышью (по 3 строки)

opt.scrolloff      = 4             -- Минимальное количество строк над/под курсором
opt.sidescrolloff  = 4             -- Минимальное количество символов слева/справа от курсора
opt.smoothscroll   = true          -- Плавный скролл длинных (завернутых) строк

opt.updatetime     = 200
opt.confirm        = true -- Подтверждение перед закрытием несохраненного файла
