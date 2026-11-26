-- ============================================================
-- 01-schema.sql  users + photo
-- 仅在数据库卷为空、容器首次启动时自动执行
-- ============================================================

-- ---------- users ----------
CREATE TABLE IF NOT EXISTS users (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account     VARCHAR(64)  NOT NULL,
  password    VARCHAR(255) NOT NULL,              -- 存哈希，不存明文
  is_deleted  SMALLINT     NOT NULL DEFAULT 0,    -- 0 正常 1 已删
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- 账号唯一：只约束“未删除”的记录，软删后账号可复用
CREATE UNIQUE INDEX uk_users_account_alive
  ON users (account)
  WHERE is_deleted = 0;

COMMENT ON TABLE  users             IS '用户表';
COMMENT ON COLUMN users.account     IS '登录账号';
COMMENT ON COLUMN users.password    IS '密码哈希';
COMMENT ON COLUMN users.is_deleted  IS '软删除：0 正常 1 已删';

-- ---------- photo ----------
CREATE TABLE IF NOT EXISTS photo (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id      BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  url          VARCHAR(512) NOT NULL,             -- 文件访问地址/相对路径
  name         VARCHAR(128) NOT NULL DEFAULT '',  -- 原始文件名
  title        VARCHAR(128),
  description  VARCHAR(500),
  size         BIGINT       NOT NULL DEFAULT 0,   -- 字节
  mime_type    VARCHAR(64)  NOT NULL DEFAULT '',  -- image/jpeg
  width        INTEGER,                           -- 可空
  height       INTEGER,                           -- 可空
  sort_order   INTEGER      NOT NULL DEFAULT 0,   -- 越小越靠前
  is_deleted   SMALLINT     NOT NULL DEFAULT 0,
  created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- 最常用查询：某用户未删除照片，按排序+时间
CREATE INDEX idx_photo_user_alive
  ON photo (user_id, is_deleted, sort_order, created_at DESC);

-- 按时间浏览/分页
CREATE INDEX idx_photo_created
  ON photo (created_at DESC);

COMMENT ON TABLE  photo              IS '用户相册照片';
COMMENT ON COLUMN photo.url          IS '文件地址，文件本体不入库';
COMMENT ON COLUMN photo.is_deleted   IS '软删除：0 正常 1 已删';
COMMENT ON COLUMN photo.sort_order   IS '自定义排序，越小越靠前';