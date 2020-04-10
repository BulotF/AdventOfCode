<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <distances>
            <xsl:apply-templates select="//cell[text()='.']" mode="beginning"/>
        </distances>
    </xsl:template>

    <!-- calcul des trajets depuis un point de départ et longueur de chacun -->
    <xsl:template match="cell" mode="beginning">
        <xsl:variable name="line" select="parent::line/count(preceding-sibling::line) +1" as="xs:integer"/>
        <xsl:variable name="column" select="count(preceding-sibling::cell) +1" as="xs:integer"/>
        <xsl:variable name="dots-around" select="(if (preceding-sibling::cell[1] = '.') then 1 else 0) 
            + (if (following-sibling::cell[1] = '.') then 1 else 0)
            + (if (parent::line/preceding-sibling::line[1]/cell[$column] = '.') then 1 else 0)
            + (if (parent::line/following-sibling::line[1]/cell[$column] = '.') then 1 else 0)" as="xs:integer"/>
        
        <!-- intersection -->
        <xsl:if test="$dots-around &gt; 2">
            <cell line="{$line}" column="{$column}" text="{text()}" in="0">
                <xsl:if test="preceding-sibling::cell[1] = '.'">
                    <xsl:apply-templates select="preceding-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="1"/>
                        <xsl:with-param name="direction" select="'left'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="following-sibling::cell[1] = '.'">
                    <xsl:apply-templates select="following-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="1"/>
                        <xsl:with-param name="direction" select="'right'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="parent::line/preceding-sibling::line[1]/cell[$column] = '.'">
                    <xsl:apply-templates select="parent::line/preceding-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="1"/>
                        <xsl:with-param name="direction" select="'up'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="parent::line/following-sibling::line[1]/cell[$column] = '.'">
                    <xsl:apply-templates select="parent::line/following-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="1"/>
                        <xsl:with-param name="direction" select="'down'"/>
                    </xsl:apply-templates>
                </xsl:if>
            </cell>
        </xsl:if>
        <!-- trou de ver -->
        <xsl:if test="$dots-around = 1">
            <!-- in et out : 1 : extérieur ; 0 : intérieur : permet de calculer les changements d'étage -->
            <xsl:variable name="in">
                <xsl:choose>
                    <xsl:when test="$line = 3 or $column = 3 or $line = 107 or $column = 107">
                        <xsl:value-of select="'1'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'0'"/>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:variable>
            <xsl:if test="preceding-sibling::cell[1] = '.'">
                <cell line="{$line}" column="{$column}" text="{concat(following-sibling::cell[1]/text(),following-sibling::cell[2]/text())}" in="{$in}">
                    <xsl:apply-templates select="preceding-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="2"/>
                        <xsl:with-param name="direction" select="'left'"/>
                    </xsl:apply-templates>
                </cell>
            </xsl:if>
            <!-- On exclut le point d'arrivée en tant que point de départ -->
            <xsl:if test="following-sibling::cell[1] = '.' and (text() != 'Z' or preceding-sibling::cell[1]/text() != 'Z')">
                <cell line="{$line}" column="{$column}" text="{concat(preceding-sibling::cell[2]/text(),preceding-sibling::cell[1]/text())}" in="{$in}">
                    <xsl:apply-templates select="following-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="2"/>
                        <xsl:with-param name="direction" select="'right'"/>
                    </xsl:apply-templates>
                </cell>
            </xsl:if>
            <xsl:if test="parent::line/preceding-sibling::line[1]/cell[$column] = '.'">
                <cell line="{$line}" column="{$column}" text="{concat(parent::line/following-sibling::line[1]/cell[$column]/text(),parent::line/following-sibling::line[2]/cell[$column]/text())}" in="{$in}">
                    <xsl:apply-templates select="parent::line/preceding-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="2"/>
                        <xsl:with-param name="direction" select="'up'"/>
                    </xsl:apply-templates>
                </cell>
            </xsl:if>
            <xsl:if test="parent::line/following-sibling::line[1]/cell[$column] = '.'">
                <cell line="{$line}" column="{$column}" text="{concat(parent::line/preceding-sibling::line[2]/cell[$column]/text(),parent::line/preceding-sibling::line[1]/cell[$column]/text())}" in="{$in}">
                    <xsl:apply-templates select="parent::line/following-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="2"/>
                        <xsl:with-param name="direction" select="'down'"/>
                    </xsl:apply-templates>
                </cell>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- calcul des distances par récurrence en passant par chacun des points sans retour -->
    <xsl:template match="cell" mode="distance">
        <xsl:param name="distance"/>
        <xsl:param name="direction"/>
        
        <xsl:variable name="line" select="parent::line/count(preceding-sibling::line) +1" as="xs:integer"/>
        <xsl:variable name="column" select="count(preceding-sibling::cell) +1" as="xs:integer"/>
        <xsl:variable name="dots-around" select="(if (preceding-sibling::cell[1] = '.') then 1 else 0) 
            + (if (following-sibling::cell[1] = '.') then 1 else 0)
            + (if (parent::line/preceding-sibling::line[1]/cell[$column] = '.') then 1 else 0)
            + (if (parent::line/following-sibling::line[1]/cell[$column] = '.') then 1 else 0)" as="xs:integer"/>
        
        <xsl:choose>
            <xsl:when test="$dots-around = 2 and text() = '.'">
                <xsl:if test="preceding-sibling::cell[1] = '.' and $direction != 'right'">
                    <xsl:apply-templates select="preceding-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="$distance + 1"/>
                        <xsl:with-param name="direction" select="'left'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="following-sibling::cell[1] = '.' and $direction != 'left'">
                    <xsl:apply-templates select="following-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="$distance + 1"/>
                        <xsl:with-param name="direction" select="'right'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="parent::line/preceding-sibling::line[1]/cell[$column] = '.' and $direction != 'down'">
                    <xsl:apply-templates select="parent::line/preceding-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="$distance + 1"/>
                        <xsl:with-param name="direction" select="'up'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="parent::line/following-sibling::line[1]/cell[$column] = '.' and $direction != 'up'">
                    <xsl:apply-templates select="parent::line/following-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="$distance + 1"/>
                        <xsl:with-param name="direction" select="'down'"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$dots-around &gt; 2">
                <cell line="{$line}" column="{$column}" text="." distance="{$distance}" out="0"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="text">
                    <xsl:choose>
                        <xsl:when test="$direction = 'left'">
                            <xsl:value-of select="concat(preceding-sibling::cell[2]/text(),preceding-sibling::cell[1]/text())"/>
                        </xsl:when>
                        <xsl:when test="$direction = 'right'">
                            <xsl:value-of select="concat(following-sibling::cell[1]/text(),following-sibling::cell[2]/text())"/>
                        </xsl:when>
                        <xsl:when test="$direction = 'up'">
                            <xsl:value-of select="concat(parent::line/preceding-sibling::line[2]/cell[$column]/text(),parent::line/preceding-sibling::line[1]/cell[$column]/text())"/>
                        </xsl:when>
                        <xsl:when test="$direction = 'down'">
                            <xsl:value-of select="concat(parent::line/following-sibling::line[1]/cell[$column]/text(),parent::line/following-sibling::line[2]/cell[$column]/text())"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="out">
                    <xsl:choose>
                        <xsl:when test="$line = 3 or $column = 3 or $line = 107 or $column = 107">
                            <xsl:value-of select="'1'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'0'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- On exclut le point de départ en tant que point d'arrivée -->
                <xsl:if test="$text != 'AA'">
                    <cell line="{$line}" column="{$column}" text="{$text}" distance="{$distance}" out="{$out}"/>    
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>